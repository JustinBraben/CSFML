const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // const t = target.result;
    
    const lib = b.addStaticLibrary(.{
        .name = "csfml",
        .target = target,
        .optimize = optimize,
    });
    lib.addIncludePath(.{ .path = "include/SFML/Graphics" });
    lib.addIncludePath(.{ .path = "src/SFML/Graphics" });
    lib.addCSourceFiles(.{
        .files = &.{
            "src/SFML/Graphics/BlendMode.cpp",
            "src/SFML/Graphics/CircleShape.cpp",
            "src/SFML/Graphics/Color.cpp",
            "src/SFML/Graphics/ConvexShape.cpp",
            "src/SFML/Graphics/Font.cpp",
            "src/SFML/Graphics/Image.cpp",
            "src/SFML/Graphics/Rect.cpp",
            "src/SFML/Graphics/RectangleShape.cpp",
            "src/SFML/Graphics/RenderStates.cpp",
            "src/SFML/Graphics/RenderTexture.cpp",
            "src/SFML/Graphics/RenderWindow.cpp",
            "src/SFML/Graphics/Shader.cpp",
            "src/SFML/Graphics/Shape.cpp",
            "src/SFML/Graphics/Sprite.cpp",
            "src/SFML/Graphics/Text.cpp",
            "src/SFML/Graphics/Texture.cpp",
            "src/SFML/Graphics/Transform.cpp",
            "src/SFML/Graphics/Transformable.cpp",
            "src/SFML/Graphics/VertexArray.cpp",
            "src/SFML/Graphics/VertexBuffer.cpp",
            "src/SFML/Graphics/View.cpp",
        },
        .flags = &.{
            "",
        },
    });

    lib.addIncludePath(.{ .path = "include" });
    lib.linkLibC();
    lib.installHeadersDirectory("include/SFML/Graphics", "Graphics");
    b.installArtifact(lib);
}