Add-Type -AssemblyName System.Drawing

$csharpCode = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public class PhotoProcessor {
    public static void LightenSkinTone(string inputPath, string outputPath, float skinBoost, float gamma) {
        using (Bitmap src = new Bitmap(inputPath)) {
            int width = src.Width;
            int height = src.Height;
            using (Bitmap dest = new Bitmap(width, height, PixelFormat.Format24bppRgb)) {
                dest.SetResolution(src.HorizontalResolution, src.VerticalResolution);

                BitmapData srcData = src.LockBits(new Rectangle(0, 0, width, height), ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);
                BitmapData destData = dest.LockBits(new Rectangle(0, 0, width, height), ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

                int stride = srcData.Stride;
                int bytes = Math.Abs(stride) * height;
                byte[] rgbValues = new byte[bytes];
                byte[] resultValues = new byte[bytes];

                Marshal.Copy(srcData.Scan0, rgbValues, 0, bytes);

                // Build 8-bit gamma lookup table for midtone lifting
                byte[] lut = new byte[256];
                for (int i = 0; i < 256; i++) {
                    double norm = i / 255.0;
                    double corrected = Math.Pow(norm, gamma);
                    int val = (int)Math.Round(corrected * 255.0);
                    lut[i] = (byte)Math.Max(0, Math.Min(255, val));
                }

                for (int y = 0; y < height; y++) {
                    int rowStart = y * stride;
                    for (int x = 0; x < width; x++) {
                        int idx = rowStart + (x * 3);
                        byte b = rgbValues[idx];
                        byte g = rgbValues[idx + 1];
                        byte r = rgbValues[idx + 2];

                        // Calculate brightness & chromaticity
                        float max = Math.Max(r, Math.Max(g, b));
                        float min = Math.Min(r, Math.Min(g, b));
                        float delta = max - min;

                        // Skin tone heuristic: R > G > B and warm undertone
                        bool isSkinLikely = (r > g) && (g >= b) && (r > 60) && (delta > 15) && (r < 245);

                        byte newR, newG, newB;

                        if (isSkinLikely) {
                            // Apply gamma lift + extra brightness boost for skin tones
                            int boostedR = (int)(lut[r] * skinBoost);
                            int boostedG = (int)(lut[g] * skinBoost);
                            int boostedB = (int)(lut[b] * (skinBoost * 0.98f)); // slight golden radiant balance

                            newR = (byte)Math.Min(255, boostedR);
                            newG = (byte)Math.Min(255, boostedG);
                            newB = (byte)Math.Min(255, boostedB);
                        } else if (max > 45 && max < 240) {
                            // General midtone soft lift for overall balanced lighting
                            newR = lut[r];
                            newG = lut[g];
                            newB = lut[b];
                        } else {
                            // Deep blacks (suit, tie, pupils) and high whites remain protected
                            newR = r;
                            newG = g;
                            newB = b;
                        }

                        resultValues[idx] = newB;
                        resultValues[idx + 1] = newG;
                        resultValues[idx + 2] = newR;
                    }
                }

                Marshal.Copy(resultValues, 0, destData.Scan0, bytes);
                src.UnlockBits(srcData);
                dest.UnlockBits(destData);

                // Save with high quality JPEG encoder
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

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Drawing"

$inputImg = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\professional_corporate_id_portrait_1793949187897.jpg"
$outputImg = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"
$outputBackup = "D:\PHOTO DESIGNING\Professional_ID_Photo_LightSkin.jpg"
$outputArtifact = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Professional_ID_Photo.jpg"

# Apply skin brightening: gamma = 0.80 (lifts midtones), skinBoost = 1.15 (adds +15% radiant brightness to skin)
[PhotoProcessor]::LightenSkinTone($inputImg, $outputImg, [float]1.15, [float]0.80)
[PhotoProcessor]::LightenSkinTone($inputImg, $outputBackup, [float]1.15, [float]0.80)
[PhotoProcessor]::LightenSkinTone($inputImg, $outputArtifact, [float]1.15, [float]0.80)

Write-Host "Skin brightening completed successfully!"
