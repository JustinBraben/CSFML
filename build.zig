const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // const t = target.result;

    // const sfml_dep = b.dependency("sfml", .{
    //     .target = target,
    //     .optimize = optimize,
    // });
    
    const lib = b.addStaticLibrary(.{
        .name = "csfml",
        .target = target,
        .optimize = optimize,
    });
    // lib.linkLibrary(sfml_dep.artifact("sfml"));
    lib.linkLibC();
    lib.linkLibCpp();

    //b.modules

    // std.debug.print("sfml path : {any}\n", .{sfml_dep.path(".")});

    lib.addIncludePath(.{ .path = "include" });
    lib.addIncludePath(.{ .path = "src" });
    lib.addCSourceFiles(.{
        .files = &system_src_files,
    });

    lib.installHeadersDirectory("include", "csfml");
    lib.installHeadersDirectory("src", "csfml");
    b.installArtifact(lib);
}

const system_src_files = [_][]const u8{
    "src/SFML/System/Alloc.cpp",
    // "src/SFML/System/Buffer.cpp",
    // "src/SFML/System/Clock.cpp",
    // "src/SFML/System/Sleep.cpp",
    // "src/SFML/System/Time.cpp",
};

const generic_src_files = [_][]const u8{
    "src/SFML/System/Alloc.cpp",
    // "src/SFML/System/Buffer.cpp"
    // "src/SFML/System/Clock.cpp",
    // "src/SFML/Graphics/BlendMode.cpp",
    // "src/SFML/Graphics/CircleShape.cpp",
    // "src/SFML/Graphics/Color.cpp",
    // "src/SFML/Graphics/ConvexShape.cpp",
    // "src/SFML/Graphics/Font.cpp",
    // "src/SFML/Graphics/Image.cpp",
    // "src/SFML/Graphics/Rect.cpp",
    // "src/SFML/Graphics/RectangleShape.cpp",
    // "src/SFML/Graphics/RenderStates.cpp",
    // "src/SFML/Graphics/RenderTexture.cpp",
    // "src/SFML/Graphics/RenderWindow.cpp",
    // "src/SFML/Graphics/Shader.cpp",
    // "src/SFML/Graphics/Shape.cpp",
    // "src/SFML/Graphics/Sprite.cpp",
    // "src/SFML/Graphics/Text.cpp",
    // "src/SFML/Graphics/Texture.cpp",
    // "src/SFML/Graphics/Transform.cpp",
    // "src/SFML/Graphics/Transformable.cpp",
    // "src/SFML/Graphics/VertexArray.cpp",
    // "src/SFML/Graphics/VertexBuffer.cpp",
    // "src/SFML/Graphics/View.cpp",
};