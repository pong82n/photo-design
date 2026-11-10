$ffmpeg = "C:\Users\MIRR\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-9.0.2-full_build\bin\ffmpeg.exe"
$workDir = "D:\PHOTO DESIGNING"
$scratch = "D:\PHOTO DESIGNING\scratch"

Write-Host "=== Rendering Architectural Walkthrough Video Scenes ==="

# Scene 0: Intro (3.5s)
$introCmd = @(
    "-loop", "1", "-i", "$scratch\card_intro.png",
    "-t", "3.5",
    "-vf", "scale=1920:1080,fade=t=in:st=0:d=1.0,fade=t=out:st=2.5:d=1.0",
    "-c:v", "libx264", "-preset", "veryfast", "-pix_fmt", "yuv420p",
    "-y", "$scratch\clip_0_intro.mp4"
)
& $ffmpeg $introCmd
Write-Host "Scene 0 (Intro) rendered."

# Scene 1: Exterior Day (5.5s)
$s1Cmd = @(
    "-loop", "1", "-i", "$workDir\Luxury_3Storey_House_Exterior_Day.jpg",
    "-i", "$scratch\overlay_scene_1.png",
    "-t", "5.5",
    "-filter_complex", "[0:v]scale=2100:1181,crop=1920:1080:'(in_w-1920)*t/5.5':0,fade=t=in:st=0:d=0.8,fade=t=out:st=4.7:d=0.8[bg];[bg][1:v]overlay=0:0[v]",
    "-map", "[v]",
    "-c:v", "libx264", "-preset", "veryfast", "-pix_fmt", "yuv420p",
    "-y", "$scratch\clip_1_ext_day.mp4"
)
& $ffmpeg $s1Cmd
Write-Host "Scene 1 (Exterior Day) rendered."

# Scene 2: Ground Floor Living (5.5s)
$s2Cmd = @(
    "-loop", "1", "-i", "$workDir\Luxury_3Storey_House_Ground_Living.jpg",
    "-i", "$scratch\overlay_scene_2.png",
    "-t", "5.5",
    "-filter_complex", "[0:v]scale=2050:1153,crop=1920:1080:'(in_w-1920)*0.5':'(in_h-1080)*t/5.5',fade=t=in:st=0:d=0.8,fade=t=out:st=4.7:d=0.8[bg];[bg][1:v]overlay=0:0[v]",
    "-map", "[v]",
    "-c:v", "libx264", "-preset", "veryfast", "-pix_fmt", "yuv420p",
    "-y", "$scratch\clip_2_living.mp4"
)
& $ffmpeg $s2Cmd
Write-Host "Scene 2 (Ground Floor Living) rendered."

# Scene 3: Master Suite (5.5s)
$s3Cmd = @(
    "-loop", "1", "-i", "$workDir\Luxury_3Storey_House_Master_Suite.jpg",
    "-i", "$scratch\overlay_scene_3.png",
    "-t", "5.5",
    "-filter_complex", "[0:v]scale=2100:1181,crop=1920:1080:'(in_w-1920)*(1-t/5.5)':0,fade=t=in:st=0:d=0.8,fade=t=out:st=4.7:d=0.8[bg];[bg][1:v]overlay=0:0[v]",
    "-map", "[v]",
    "-c:v", "libx264", "-preset", "veryfast", "-pix_fmt", "yuv420p",
    "-y", "$scratch\clip_3_suite.mp4"
)
& $ffmpeg $s3Cmd
Write-Host "Scene 3 (Master Suite) rendered."

# Scene 4: Rooftop Lounge (5.5s)
$s4Cmd = @(
    "-loop", "1", "-i", "$workDir\Luxury_3Storey_House_Rooftop_Lounge.jpg",
    "-i", "$scratch\overlay_scene_4.png",
    "-t", "5.5",
    "-filter_complex", "[0:v]scale=2050:1153,crop=1920:1080:'(in_w-1920)*t/5.5':'(in_h-1080)*0.5',fade=t=in:st=0:d=0.8,fade=t=out:st=4.7:d=0.8[bg];[bg][1:v]overlay=0:0[v]",
    "-map", "[v]",
    "-c:v", "libx264", "-preset", "veryfast", "-pix_fmt", "yuv420p",
    "-y", "$scratch\clip_4_rooftop.mp4"
)
& $ffmpeg $s4Cmd
Write-Host "Scene 4 (Rooftop Lounge) rendered."

# Scene 5: Exterior Night (5.5s)
$s5Cmd = @(
    "-loop", "1", "-i", "$workDir\Luxury_3Storey_House_Exterior_Night.jpg",
    "-i", "$scratch\overlay_scene_5.png",
    "-t", "5.5",
    "-filter_complex", "[0:v]scale=2100:1181,crop=1920:1080:'(in_w-1920)*0.5':'(in_h-1080)*(1-t/5.5)',fade=t=in:st=0:d=0.8,fade=t=out:st=4.7:d=0.8[bg];[bg][1:v]overlay=0:0[v]",
    "-map", "[v]",
    "-c:v", "libx264", "-preset", "veryfast", "-pix_fmt", "yuv420p",
    "-y", "$scratch\clip_5_ext_night.mp4"
)
& $ffmpeg $s5Cmd
Write-Host "Scene 5 (Exterior Night) rendered."

# Scene 6: Outro (3.5s)
$outroCmd = @(
    "-loop", "1", "-i", "$scratch\card_outro.png",
    "-t", "3.5",
    "-vf", "scale=1920:1080,fade=t=in:st=0:d=1.0,fade=t=out:st=2.5:d=1.0",
    "-c:v", "libx264", "-preset", "veryfast", "-pix_fmt", "yuv420p",
    "-y", "$scratch\clip_6_outro.mp4"
)
& $ffmpeg $outroCmd
Write-Host "Scene 6 (Outro) rendered."

# Concatenate all clips
$concatFile = "$scratch\concat_list.txt"
@"
file 'clip_0_intro.mp4'
file 'clip_1_ext_day.mp4'
file 'clip_2_living.mp4'
file 'clip_3_suite.mp4'
file 'clip_4_rooftop.mp4'
file 'clip_5_ext_night.mp4'
file 'clip_6_outro.mp4'
"@ | Out-File -Encoding ASCII $concatFile

$videoOnly = "$scratch\walkthrough_video_only.mp4"
& $ffmpeg -f concat -safe 0 -i $concatFile -c copy -y $videoOnly
Write-Host "Visual sequence merged."

# Synthesize Ambient Audio Soundtrack (total length ~34.5s)
$audioTrack = "$scratch\ambient_audio.aac"
$audioSynthCmd = @(
    "-f", "lavfi",
    "-i", "sine=frequency=130.81:duration=35[b1];sine=frequency=196.00:duration=35[b2];sine=frequency=261.63:duration=35[b3];sine=frequency=329.63:duration=35[b4];[b1][b2][b3][b4]amix=inputs=4:duration=longest[raw];[raw]lowpass=f=450,volume=0.35,afade=t=in:st=0:d=2.5,afade=t=out:st=31:d=3.5[a]",
    "-map", "[a]",
    "-c:a", "aac", "-b:a", "192k",
    "-y", $audioTrack
)
& $ffmpeg $audioSynthCmd
Write-Host "Ambient luxury audio soundtrack synthesized."

# Final Mux: Video + Audio into Master MP4
$finalOutput = "$workDir\Luxury_3Storey_House_Walkthrough.mp4"
$artifactOutput = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\Luxury_3Storey_House_Walkthrough.mp4"

$muxCmd = @(
    "-i", $videoOnly,
    "-i", $audioTrack,
    "-c:v", "copy",
    "-c:a", "aac",
    "-shortest",
    "-y", $finalOutput
)
& $ffmpeg $muxCmd

Copy-Item $finalOutput $artifactOutput -Force
Write-Host "Master Walkthrough Video rendered successfully to $finalOutput and artifact directory!"
