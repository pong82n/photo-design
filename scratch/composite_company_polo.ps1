Add-Type -AssemblyName System.Drawing

$csharpPolo = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class PoloCompositor {
    public static void ApplyCompanyPolo(string inputPath, string outputPath) {
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

                    // 1. Draw base photo (head, face, hair, studio backdrop)
                    g.DrawImage(baseBmp, 0, 0, w, h);

                    float cx = w * 0.50f;
                    float neckLeftX = w * 0.408f;
                    float neckRightX = w * 0.592f;
                    float neckBaseY = h * 0.648f;
                    float throatDipY = h * 0.685f;

                    // 2. Main Polo Body Path (Shoulders & Chest)
                    GraphicsPath bodyPath = new GraphicsPath();
                    bodyPath.StartFigure();
                    bodyPath.AddLine(0, h * 0.74f, neckLeftX, neckBaseY);
                    bodyPath.AddBezier(neckLeftX, neckBaseY, cx - (w * 0.05f), throatDipY, cx + (w * 0.05f), throatDipY, neckRightX, neckBaseY);
                    bodyPath.AddLine(neckRightX, neckBaseY, w, h * 0.74f);
                    bodyPath.AddLine(w, h, 0, h);
                    bodyPath.CloseFigure();

                    // Rich Pique Navy Fabric Gradient
                    using (LinearGradientBrush bodyBrush = new LinearGradientBrush(
                        new PointF(w * 0.3f, h * 0.65f),
                        new PointF(w * 0.7f, h * 1.0f),
                        Color.FromArgb(255, 17, 28, 46),   // premium corporate navy
                        Color.FromArgb(255, 10, 18, 30)    // deep obsidian navy
                    )) {
                        g.FillPath(bodyBrush, bodyPath);
                    }

                    // Subtle fabric texture & shoulder lighting
                    using (GraphicsPath shoulderHighlight = new GraphicsPath()) {
                        shoulderHighlight.AddBezier(0, h * 0.74f, w * 0.2f, h * 0.71f, neckLeftX, neckBaseY + (h * 0.02f), neckLeftX, neckBaseY);
                        shoulderHighlight.AddLine(neckLeftX, neckBaseY, 0, h * 0.74f);
                        using (LinearGradientBrush hlBrush = new LinearGradientBrush(
                            new PointF(0, h * 0.71f),
                            new PointF(w * 0.35f, h * 0.75f),
                            Color.FromArgb(35, 255, 255, 255),
                            Color.FromArgb(0, 255, 255, 255)
                        )) {
                            g.FillPath(hlBrush, shoulderHighlight);
                        }
                    }

                    // 3. Center Button Placket
                    float placketW = w * 0.056f;
                    float placketLeft = cx - (placketW * 0.5f);
                    float placketTop = throatDipY - (h * 0.005f);
                    float placketBottom = h * 0.815f;
                    float placketH = placketBottom - placketTop;

                    RectangleF placketRect = new RectangleF(placketLeft, placketTop, placketW, placketH);
                    using (LinearGradientBrush placketBrush = new LinearGradientBrush(
                        placketRect,
                        Color.FromArgb(255, 24, 38, 60),
                        Color.FromArgb(255, 14, 22, 36),
                        LinearGradientMode.Horizontal
                    )) {
                        g.FillRectangle(placketBrush, placketRect);
                    }

                    // Placket Edge Seam Stitching
                    using (Pen stitchPen = new Pen(Color.FromArgb(180, 255, 87, 34), 1.2f)) {
                        stitchPen.DashStyle = DashStyle.Dot;
                        g.DrawLine(stitchPen, placketLeft + 2, placketTop, placketLeft + 2, placketBottom);
                        g.DrawLine(stitchPen, placketLeft + placketW - 2, placketTop, placketLeft + placketW - 2, placketBottom);
                        g.DrawLine(stitchPen, placketLeft, placketBottom, placketLeft + placketW, placketBottom);
                    }

                    // 4. Pearl Buttons on Placket
                    float[] buttonYs = new float[] { placketTop + (placketH * 0.32f), placketTop + (placketH * 0.70f) };
                    float btnRadius = w * 0.009f;

                    foreach (float by in buttonYs) {
                        // Button rim shadow
                        g.FillEllipse(new SolidBrush(Color.FromArgb(120, 0, 0, 0)), cx - btnRadius + 1, by - btnRadius + 1, btnRadius * 2, btnRadius * 2);
                        // Pearl button body
                        using (LinearGradientBrush btnBrush = new LinearGradientBrush(
                            new PointF(cx - btnRadius, by - btnRadius),
                            new PointF(cx + btnRadius, by + btnRadius),
                            Color.FromArgb(255, 248, 250, 252),
                            Color.FromArgb(255, 203, 213, 225)
                        )) {
                            g.FillEllipse(btnBrush, cx - btnRadius, by - btnRadius, btnRadius * 2, btnRadius * 2);
                        }
                        // Button inner groove & 4 thread holes
                        using (Pen rimPen = new Pen(Color.FromArgb(180, 148, 163, 184), 0.8f)) {
                            g.DrawEllipse(rimPen, cx - (btnRadius * 0.7f), by - (btnRadius * 0.7f), btnRadius * 1.4f, btnRadius * 1.4f);
                        }
                        // Orange thread center cross
                        using (Pen threadPen = new Pen(Color.FromArgb(255, 230, 74, 25), 1.0f)) {
                            float d = btnRadius * 0.35f;
                            g.DrawLine(threadPen, cx - d, by, cx + d, by);
                            g.DrawLine(threadPen, cx, by - d, cx, by + d);
                        }
                    }

                    // 5. Classic Folded Polo Collar Wings (Left and Right)
                    // LEFT COLLAR WING
                    PointF[] leftCollar = new PointF[] {
                        new PointF(neckLeftX - (w * 0.01f), neckBaseY),                      // back neck joint
                        new PointF(cx - (w * 0.015f), throatDipY - (h * 0.012f)),           // center inner throat
                        new PointF(cx - (w * 0.005f), throatDipY + (h * 0.025f)),           // placket overlap
                        new PointF(neckLeftX - (w * 0.045f), neckBaseY + (h * 0.082f)),     // collar sharp point
                        new PointF(neckLeftX - (w * 0.038f), neckBaseY + (h * 0.042f)),     // outer fold curve
                        new PointF(neckLeftX - (w * 0.01f), neckBaseY)
                    };

                    GraphicsPath leftCollarPath = new GraphicsPath();
                    leftCollarPath.AddLines(leftCollar);
                    leftCollarPath.CloseFigure();

                    // RIGHT COLLAR WING
                    PointF[] rightCollar = new PointF[] {
                        new PointF(neckRightX + (w * 0.01f), neckBaseY),                    // back neck joint
                        new PointF(cx + (w * 0.015f), throatDipY - (h * 0.012f)),          // center inner throat
                        new PointF(cx + (w * 0.005f), throatDipY + (h * 0.025f)),          // placket overlap
                        new PointF(neckRightX + (w * 0.045f), neckBaseY + (h * 0.082f)),    // collar sharp point
                        new PointF(neckRightX + (w * 0.038f), neckBaseY + (h * 0.042f)),    // outer fold curve
                        new PointF(neckRightX + (w * 0.01f), neckBaseY)
                    };

                    GraphicsPath rightCollarPath = new GraphicsPath();
                    rightCollarPath.AddLines(rightCollar);
                    rightCollarPath.CloseFigure();

                    // Collar Drop Shadow onto Shirt
                    using (PathGradientBrush pgbLeft = new PathGradientBrush(leftCollarPath)) {
                        Matrix mx = new Matrix();
                        mx.Translate(2, 3);
                        GraphicsPath shadowLeft = (GraphicsPath)leftCollarPath.Clone();
                        shadowLeft.Transform(mx);
                        g.FillPath(new SolidBrush(Color.FromArgb(100, 0, 0, 0)), shadowLeft);
                    }
                    using (PathGradientBrush pgbRight = new PathGradientBrush(rightCollarPath)) {
                        Matrix mx = new Matrix();
                        mx.Translate(-2, 3);
                        GraphicsPath shadowRight = (GraphicsPath)rightCollarPath.Clone();
                        shadowRight.Transform(mx);
                        g.FillPath(new SolidBrush(Color.FromArgb(100, 0, 0, 0)), shadowRight);
                    }

                    // Fill Collar Wings with Structured Navy Fabric
                    using (LinearGradientBrush collarBrushLeft = new LinearGradientBrush(
                        new PointF(neckLeftX, neckBaseY),
                        new PointF(neckLeftX - (w * 0.045f), neckBaseY + (h * 0.082f)),
                        Color.FromArgb(255, 30, 48, 76),   // lighter navy fold
                        Color.FromArgb(255, 18, 28, 46)    // body navy
                    )) {
                        g.FillPath(collarBrushLeft, leftCollarPath);
                    }

                    using (LinearGradientBrush collarBrushRight = new LinearGradientBrush(
                        new PointF(neckRightX, neckBaseY),
                        new PointF(neckRightX + (w * 0.045f), neckBaseY + (h * 0.082f)),
                        Color.FromArgb(255, 32, 50, 80),   // studio key light side
                        Color.FromArgb(255, 18, 28, 46)
                    )) {
                        g.FillPath(collarBrushRight, rightCollarPath);
                    }

                    // Contrast Orange Tipping on Collar Outer Edges
                    using (Pen orangeTipping = new Pen(Color.FromArgb(255, 255, 87, 34), 2.2f)) {
                        // Left collar tip
                        g.DrawLine(orangeTipping, leftCollar[3], leftCollar[4]);
                        g.DrawLine(orangeTipping, leftCollar[2], leftCollar[3]);

                        // Right collar tip
                        g.DrawLine(orangeTipping, rightCollar[3], rightCollar[4]);
                        g.DrawLine(orangeTipping, rightCollar[2], rightCollar[3]);
                    }

                    // Subtle inner shadow under chin
                    using (GraphicsPath throatShadow = new GraphicsPath()) {
                        throatShadow.AddBezier(neckLeftX, neckBaseY, cx, throatDipY, cx, throatDipY, neckRightX, neckBaseY);
                        throatShadow.AddLine(neckRightX, neckBaseY, neckLeftX, neckBaseY);
                        using (SolidBrush tsBrush = new SolidBrush(Color.FromArgb(70, 0, 0, 0))) {
                            g.FillPath(tsBrush, throatShadow);
                        }
                    }

                    // 6. Draw Official MIRR Construction Services Company Logo on Left Chest
                    float logoX = w * 0.235f;
                    float logoY = h * 0.785f;
                    float iconSize = h * 0.054f;

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

                    using (Font titleFont = new Font("Arial", h * 0.0215f, FontStyle.Bold))
                    using (Font subFont = new Font("Arial", h * 0.0112f, FontStyle.Bold))
                    using (Font deptFont = new Font("Arial", h * 0.0092f, FontStyle.Regular)) {
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
                            g.DrawString("SERVICES & ENGINEERING", subFont, subBrush, textX, logoY + (h * 0.027f));
                        }

                        // Department tag: "SITE OPERATIONS // CIVIL WORKS"
                        using (SolidBrush tagBrush = new SolidBrush(Color.FromArgb(255, 180, 100))) {
                            g.DrawString("SITE OPERATIONS // CIVIL WORKS", deptFont, tagBrush, textX, logoY + (h * 0.043f));
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

Add-Type -TypeDefinition $csharpPolo -ReferencedAssemblies "System.Drawing"

$input = "D:\PHOTO DESIGNING\Professional_ID_Photo_Fuller.jpg"
$outputPolo = "D:\PHOTO DESIGNING\Professional_ID_Photo_CompanyPolo.jpg"
$outputMain = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"
$outputArtifact = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Professional_ID_Photo.jpg"
$outputArtifactPolo = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Professional_ID_Photo_CompanyPolo.jpg"

[PoloCompositor]::ApplyCompanyPolo($input, $outputPolo)
Copy-Item $outputPolo $outputMain -Force
Copy-Item $outputPolo $outputArtifact -Force
Copy-Item $outputPolo $outputArtifactPolo -Force
Copy-Item $outputPolo "D:\PHOTO DESIGNING\Engr_Raffy_Soguilon_Professional_ID_Photo.jpg" -Force

Write-Host "Company Polo Shirt compositing completed successfully!"
