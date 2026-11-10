Add-Type -AssemblyName System.Drawing

$csharpBg = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public class BackgroundLighter {
    public static void LightenBackground(string inputPath, string outputPath, float liftAmount) {
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

                for (int y = 0; y < height; y++) {
                    int rowStart = y * stride;
                    for (int x = 0; x < width; x++) {
                        int idx = rowStart + (x * 3);
                        byte b = srcPixels[idx];
                        byte g = srcPixels[idx + 1];
                        byte r = srcPixels[idx + 2];

                        float max = Math.Max(r, Math.Max(g, b));
                        float min = Math.Min(r, Math.Min(g, b));
                        float delta = max - min; // chromaticity / saturation

                        // Background characteristics:
                        // Cool neutral gray: delta is very small (< 16), brightness > 75
                        // Skin has delta > 30 and R > G > B
                        // Navy polo and hair have max < 65

                        float bgWeight = 0f;
                        if (min > 70 && delta < 22) {
                            if (delta <= 10) {
                                bgWeight = 1.0f;
                            } else {
                                // Smooth feathering between delta 10 and 22
                                bgWeight = 1.0f - ((delta - 10f) / 12f);
                            }
                        }

                        byte newR, newG, newB;
                        if (bgWeight > 0f) {
                            // Brighten background smoothly toward light silver / off-white
                            // Target around +55 to +70 brightness lift
                            float added = liftAmount * bgWeight;
                            newR = (byte)Math.Min(245, (int)(r + added));
                            newG = (byte)Math.Min(248, (int)(g + added));
                            newB = (byte)Math.Min(252, (int)(b + added));
                        } else {
                            newR = r;
                            newG = g;
                            newB = b;
                        }

                        destPixels[idx] = newB;
                        destPixels[idx + 1] = newG;
                        destPixels[idx + 2] = newR;
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

Add-Type -TypeDefinition $csharpBg -ReferencedAssemblies "System.Drawing"

$input = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"
$output = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"
$outputLightBg = "D:\PHOTO DESIGNING\Professional_ID_Photo_LightBg.jpg"
$outputArtifact = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Professional_ID_Photo.jpg"
$outputArtifactLightBg = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Professional_ID_Photo_LightBg.jpg"

# liftAmount = 58f (brightens background by ~58 luminance levels into a clean light studio gray/off-white)
[BackgroundLighter]::LightenBackground($input, $outputLightBg, [float]58.0)
Copy-Item $outputLightBg $output -Force
Copy-Item $outputLightBg $outputArtifact -Force
Copy-Item $outputLightBg $outputArtifactLightBg -Force
Copy-Item $outputLightBg "D:\PHOTO DESIGNING\Engr_Raffy_Soguilon_Professional_ID_Photo.jpg" -Force

Write-Host "Background lightening completed successfully!"
