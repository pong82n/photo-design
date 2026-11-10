Add-Type -AssemblyName System.Drawing

$csharpCompositor = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class ShirtCompositor {
    public static void ApplyCompanyTShirt(string inputPath, string outputPath) {
        using (Bitmap baseBmp = new Bitmap(inputPath)) {
            int w = baseBmp.Width;
            int h = baseBmp.Height;

            using (Bitmap result = new Bitmap(w, h, PixelFormat.Format24bppRgb)) {
                result.SetResolution(baseBmp.HorizontalResolution, baseBmp.VerticalResolution);

                using (Graphics g = Graphics.FromImage(result)) {
                    g.SmoothingMode = SmoothingMode.AntiAlias;
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                    // 1. Draw original base (face, head, studio background)
                    g.DrawImage(baseBmp, 0, 0, w, h);

                    // Measurements for neck and chest
                    float centerX = w * 0.50f;
                    // Neck collar curve points
                    float neckLeftX = w * 0.405f;
                    float neckRightX = w * 0.595f;
                    float neckDipY = h * 0.690f; // lowest point of crew-neck collar
                    float neckTopY = h * 0.648f; // where collar meets the neck sides

                    // 2. Define the T-Shirt Body Polygon/Path
                    // Shoulders extend to left edge (x=0) and right edge (x=w), down to bottom (y=h)
                    GraphicsPath shirtPath = new GraphicsPath();
                    shirtPath.StartFigure();
                    
                    // Left shoulder start
                    shirtPath.AddLine(0, h * 0.74f, neckLeftX, neckTopY);
                    // Crew neck curve under throat
                    shirtPath.AddBezier(
                        neckLeftX, neckTopY,
                        neckLeftX + (centerX - neckLeftX) * 0.4f, neckDipY,
                        centerX + (neckRightX - centerX) * 0.6f, neckDipY,
                        neckRightX, neckTopY
                    );
                    // Right shoulder
                    shirtPath.AddLine(neckRightX, neckTopY, w, h * 0.74f);
                    shirtPath.AddLine(w, h, 0, h);
                    shirtPath.CloseFigure();

                    // 3. Fill Shirt with Rich Corporate Navy Fabric Gradient
                    // Studio lighting comes slightly from top-right
                    using (LinearGradientBrush shirtBrush = new LinearGradientBrush(
                        new PointF(w * 0.3f, h * 0.65f),
                        new PointF(w * 0.7f, h * 1.0f),
                        Color.FromArgb(255, 18, 30, 48),  // dark corporate navy
                        Color.FromArgb(255, 11, 19, 32)   // deep obsidian navy
                    )) {
                        g.FillPath(shirtBrush, shirtPath);
                    }

                    // Add subtle fabric shoulder highlights and folds
                    using (GraphicsPath shoulderHighlight = new GraphicsPath()) {
                        shoulderHighlight.AddBezier(
                            0, h * 0.74f,
                            w * 0.2f, h * 0.72f,
                            neckLeftX, neckTopY + (h * 0.02f),
                            neckLeftX, neckTopY
                        );
                        shoulderHighlight.AddLine(neckLeftX, neckTopY, 0, h * 0.74f);
                        using (LinearGradientBrush hlBrush = new LinearGradientBrush(
                            new PointF(0, h * 0.72f),
                            new PointF(w * 0.4f, h * 0.76f),
                            Color.FromArgb(40, 255, 255, 255),
                            Color.FromArgb(0, 255, 255, 255)
                        )) {
                            g.FillPath(hlBrush, shoulderHighlight);
                        }
                    }

                    // 4. Draw Ribbed Crew-Neck Collar Band
                    GraphicsPath collarBand = new GraphicsPath();
                    float bandThickness = h * 0.016f;
                    // Inner curve (contacts neck skin)
                    collarBand.AddBezier(
                        neckLeftX, neckTopY,
                        neckLeftX + (centerX - neckLeftX) * 0.4f, neckDipY,
                        centerX + (neckRightX - centerX) * 0.6f, neckDipY,
                        neckRightX, neckTopY
                    );
                    // Outer curve (contacts shirt body)
                    collarBand.AddBezier(
                        neckRightX, neckTopY + bandThickness,
                        centerX + (neckRightX - centerX) * 0.6f, neckDipY + bandThickness,
                        neckLeftX + (centerX - neckLeftX) * 0.4f, neckDipY + bandThickness,
                        neckLeftX, neckTopY + bandThickness
                    );
                    collarBand.CloseFigure();

                    using (LinearGradientBrush bandBrush = new LinearGradientBrush(
                        new PointF(centerX, neckTopY),
                        new PointF(centerX, neckDipY + bandThickness),
                        Color.FromArgb(255, 26, 42, 66),
                        Color.FromArgb(255, 14, 23, 38)
                    )) {
                        g.FillPath(bandBrush, collarBand);
                    }

                    // Delicate seam line around collar
                    using (Pen seamPen = new Pen(Color.FromArgb(120, 255, 87, 34), 1.8f)) { // subtle orange security thread accent
                        g.DrawBezier(
                            seamPen,
                            neckLeftX, neckTopY + bandThickness,
                            neckLeftX + (centerX - neckLeftX) * 0.4f, neckDipY + bandThickness,
                            centerX + (neckRightX - centerX) * 0.6f, neckDipY + bandThickness,
                            neckRightX, neckTopY + bandThickness
                        );
                    }

                    // 5. Soft Neck Drop Shadow (creates realistic 3D depth onto collar)
                    using (GraphicsPath shadowPath = new GraphicsPath()) {
                        shadowPath.AddBezier(
                            neckLeftX, neckTopY,
                            neckLeftX + (centerX - neckLeftX) * 0.4f, neckDipY,
                            centerX + (neckRightX - centerX) * 0.6f, neckDipY,
                            neckRightX, neckTopY
                        );
                        shadowPath.AddBezier(
                            neckRightX, neckTopY + (bandThickness * 0.7f),
                            centerX + (neckRightX - centerX) * 0.6f, neckDipY + (bandThickness * 0.7f),
                            neckLeftX + (centerX - neckLeftX) * 0.4f, neckDipY + (bandThickness * 0.7f),
                            neckLeftX, neckTopY + (bandThickness * 0.7f)
                        );
                        shadowPath.CloseFigure();
                        using (SolidBrush shadowBrush = new SolidBrush(Color.FromArgb(90, 0, 0, 0))) {
                            g.FillPath(shadowBrush, shadowPath);
                        }
                    }

                    // 6. Draw Official MIRR Construction Services Company Logo on Left Chest
                    // Left chest coordinates: x ~ 0.24w to 0.44w, y ~ 0.77h
                    float logoX = w * 0.245f;
                    float logoY = h * 0.785f;
                    float iconSize = h * 0.055f;

                    // Hexagon Logo Icon
                    PointF[] hexPoints = new PointF[6];
                    float hexRadius = iconSize * 0.5f;
                    float hexCenterX = logoX + hexRadius;
                    float hexCenterY = logoY + hexRadius;
                    for (int i = 0; i < 6; i++) {
                        double angle = (Math.PI / 3.0) * i - (Math.PI / 6.0);
                        hexPoints[i] = new PointF(
                            hexCenterX + hexRadius * (float)Math.Cos(angle),
                            hexCenterY + hexRadius * (float)Math.Sin(angle)
                        );
                    }

                    // Fill Hexagon with Construction Orange
                    using (LinearGradientBrush hexBrush = new LinearGradientBrush(
                        new PointF(hexCenterX - hexRadius, hexCenterY - hexRadius),
                        new PointF(hexCenterX + hexRadius, hexCenterY + hexRadius),
                        Color.FromArgb(255, 255, 87, 34),
                        Color.FromArgb(255, 230, 74, 25)
                    )) {
                        g.FillPolygon(hexBrush, hexPoints);
                    }

                    // Draw White "M" Monogram inside Hexagon
                    using (Pen mPen = new Pen(Color.White, iconSize * 0.14f)) {
                        mPen.StartCap = LineCap.Round;
                        mPen.EndCap = LineCap.Round;
                        mPen.LineJoin = LineJoin.Round;
                        float pLeft = hexCenterX - hexRadius * 0.48f;
                        float pRight = hexCenterX + hexRadius * 0.48f;
                        float pTop = hexCenterY - hexRadius * 0.42f;
                        float pBottom = hexCenterY + hexRadius * 0.45f;
                        float pMidY = hexCenterY + hexRadius * 0.05f;

                        PointF[] mPoints = new PointF[] {
                            new PointF(pLeft, pBottom),
                            new PointF(pLeft, pTop),
                            new PointF(hexCenterX, pMidY),
                            new PointF(pRight, pTop),
                            new PointF(pRight, pBottom)
                        };
                        g.DrawLines(mPen, mPoints);
                    }

                    // Company Typography beside Logo
                    float textX = logoX + iconSize + (w * 0.015f);

                    using (Font titleFont = new Font("Arial", h * 0.022f, FontStyle.Bold))
                    using (Font subFont = new Font("Arial", h * 0.0115f, FontStyle.Bold))
                    using (Font deptFont = new Font("Arial", h * 0.0095f, FontStyle.Regular)) {
                        // "MIRR" in White
                        using (SolidBrush whiteBrush = new SolidBrush(Color.White)) {
                            g.DrawString("MIRR", titleFont, whiteBrush, textX, logoY - (h * 0.002f));
                        }

                        // "CONSTRUCTION" in Orange
                        using (SolidBrush orangeBrush = new SolidBrush(Color.FromArgb(255, 255, 112, 67))) {
                            float mirrWidth = g.MeasureString("MIRR ", titleFont).Width;
                            g.DrawString("CONSTRUCTION", titleFont, orangeBrush, textX + mirrWidth - (w * 0.005f), logoY - (h * 0.002f));
                        }

                        // Subtitle: "SERVICES & ENGINEERING"
                        using (SolidBrush subBrush = new SolidBrush(Color.FromArgb(210, 226, 240))) {
                            g.DrawString("SERVICES & ENGINEERING", subFont, subBrush, textX, logoY + (h * 0.028f));
                        }

                        // Department tag: "PROJECT SITE OPERATIONS"
                        using (SolidBrush tagBrush = new SolidBrush(Color.FromArgb(255, 180, 100))) {
                            g.DrawString("SITE OPERATIONS // CIVIL WORKS", deptFont, tagBrush, textX, logoY + (h * 0.044f));
                        }
                    }
                }

                // 7. Save output image
                ImageCodecInfo jpgEncoder = GetEncoder(ImageFormat.Jpeg);
                EncoderParameters myEncoderParameters = new EncoderParameters(1);
                myEncoderParameters.Param[0] = new EncoderParameter(Encoder.Quality, 96L);

                result.Save(outputPath, jpgEncoder, myEncoderParameters);
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

Add-Type -TypeDefinition $csharpCompositor -ReferencedAssemblies "System.Drawing"

$input = "D:\PHOTO DESIGNING\Professional_ID_Photo_Fuller.jpg"
$outputShirt = "D:\PHOTO DESIGNING\Professional_ID_Photo_CompanyShirt.jpg"
$outputMain = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"
$outputArtifact = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Professional_ID_Photo.jpg"
$outputArtifactShirt = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Professional_ID_Photo_CompanyShirt.jpg"

[ShirtCompositor]::ApplyCompanyTShirt($input, $outputShirt)
Copy-Item $outputShirt $outputMain -Force
Copy-Item $outputShirt $outputArtifact -Force
Copy-Item $outputShirt $outputArtifactShirt -Force
Copy-Item $outputShirt "D:\PHOTO DESIGNING\Engr_Raffy_Soguilon_Professional_ID_Photo.jpg" -Force

Write-Host "Company T-Shirt compositing completed successfully!"
