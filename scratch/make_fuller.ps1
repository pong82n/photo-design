Add-Type -AssemblyName System.Drawing

$csharpMorph = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public class FaceMorpher {
    public static void MakeFuller(string inputPath, string outputPath, float maxExpansion) {
        using (Bitmap src = new Bitmap(inputPath)) {
            int width = src.Width;
            int height = src.Height;

            using (Bitmap dest = new Bitmap(width, height, PixelFormat.Format24bppRgb)) {
                dest.SetResolution(src.HorizontalResolution, src.VerticalResolution);

                BitmapData srcData = src.LockBits(new Rectangle(0, 0, width, height), ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);
                BitmapData destData = dest.LockBits(new Rectangle(0, 0, width, height), ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

                int stride = srcData.Stride;
                int bytes = Math.Abs(stride) * height;
                byte[] srcPixels = new byte[bytes];
                byte[] destPixels = new byte[bytes];

                Marshal.Copy(srcData.Scan0, srcPixels, 0, bytes);

                float centerX = width * 0.50f;
                // Face vertical landmarks:
                // Eyes ~ 0.38, Nose ~ 0.46, Cheeks ~ 0.50 - 0.56, Jaw/Chin ~ 0.58 - 0.65, Neck ~ 0.65 - 0.78
                float yStart = height * 0.42f; // start below eyes
                float yPeak = height * 0.56f;  // peak widening at lower cheeks & jaw
                float yEnd = height * 0.82f;   // taper out at collar/shoulders

                for (int y = 0; y < height; y++) {
                    float yFactor = 0f;
                    if (y >= yStart && y <= yPeak) {
                        // Rise smoothly from below eyes to cheeks/jaw
                        float t = (y - yStart) / (yPeak - yStart);
                        yFactor = t * t * (3f - 2f * t); // smoothstep
                    } else if (y > yPeak && y <= yEnd) {
                        // Taper down neck to collar
                        float t = (yEnd - y) / (yEnd - yPeak);
                        yFactor = t * t * (3f - 2f * t); // smoothstep
                    }

                    int rowStart = y * stride;

                    for (int x = 0; x < width; x++) {
                        float dx = (x - centerX) / (width * 0.5f); // -1.0 to 1.0
                        float absDx = Math.Abs(dx);

                        // Horizontal envelope: max effect around cheeks/jawline (absDx ~ 0.2 to 0.6), tapering at center and outer frame
                        float xEnvelope = 0f;
                        if (absDx < 0.85f) {
                            // Cosine bell curve across face width
                            xEnvelope = (float)Math.Sin(Math.PI * (absDx / 0.85f));
                        }

                        float morphFactor = maxExpansion * yFactor * xEnvelope;

                        // Calculate source X (pull inward from center to expand outward)
                        float srcX = centerX + (x - centerX) / (1f + morphFactor);
                        float srcY = y; // keep vertical scale stable

                        // Clamp bounds
                        srcX = Math.Max(0f, Math.Min(width - 1.001f, srcX));

                        // Bilinear interpolation
                        int x0 = (int)srcX;
                        int x1 = Math.Min(x0 + 1, width - 1);
                        float xFrac = srcX - x0;

                        int srcIdx0 = y * stride + (x0 * 3);
                        int srcIdx1 = y * stride + (x1 * 3);

                        byte b0 = srcPixels[srcIdx0];
                        byte g0 = srcPixels[srcIdx0 + 1];
                        byte r0 = srcPixels[srcIdx0 + 2];

                        byte b1 = srcPixels[srcIdx1];
                        byte g1 = srcPixels[srcIdx1 + 1];
                        byte r1 = srcPixels[srcIdx1 + 2];

                        byte b = (byte)(b0 + (b1 - b0) * xFrac);
                        byte g = (byte)(g0 + (g1 - g0) * xFrac);
                        byte r = (byte)(r0 + (r1 - r0) * xFrac);

                        int destIdx = rowStart + (x * 3);
                        destPixels[destIdx] = b;
                        destPixels[destIdx + 1] = g;
                        destPixels[destIdx + 2] = r;
                    }
                }

                Marshal.Copy(destPixels, 0, destData.Scan0, bytes);
                src.UnlockBits(srcData);
                dest.UnlockBits(destData);

                ImageCodecInfo jpgEncoder = GetEncoder(ImageFormat.Jpeg);
                EncoderParameters myEncoderParameters = new EncoderParameters(1);
                myEncoderParameters.Param[0] = new EncoderParameter(Encoder.Quality, 96L);

                dest.Save(outputPath, jpgEncoder, myEncoderParameters);
            }
        }
    }

    private static ImageCodecInfo GetEncoder(ImageFormat format) {
        ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
        foreach (ImageCodecInfo codec in codecs) {
            if (codec.FormatID == format.Guid) {
                return codec;
            }
        }
        return null;
    }
}
"@

Add-Type -TypeDefinition $csharpMorph -ReferencedAssemblies "System.Drawing"

$input = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"
$output = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"
$outputFuller = "D:\PHOTO DESIGNING\Professional_ID_Photo_Fuller.jpg"
$outputArtifact = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Professional_ID_Photo.jpg"
$outputArtifactFuller = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Professional_ID_Photo_Fuller.jpg"

# maxExpansion: 0.07 (7% fuller cheeks & jawline - natural, pleasant, not exaggerated)
[FaceMorpher]::MakeFuller($input, $outputFuller, [float]0.075)
Copy-Item $outputFuller $output -Force
Copy-Item $outputFuller $outputArtifact -Force
Copy-Item $outputFuller $outputArtifactFuller -Force
Copy-Item $outputFuller "D:\PHOTO DESIGNING\Engr_Raffy_Soguilon_Professional_ID_Photo.jpg" -Force

Write-Host "Face morphing (fuller cheeks & jawline) completed successfully!"
