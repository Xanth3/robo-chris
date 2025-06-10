const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable(.{
        .name = "robo-chris",
        .target = target,
        .optimize = mode,
    });

    exe.addCSourceFiles(&.{}, &.{});
    exe.addIncludePath(".");
    exe.addFileSource("main.zig");

    b.installArtifact(exe);
}
