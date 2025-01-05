const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const dep_opts = .{ .target = target, .optimize = optimize };

    const string_builder_module = b.dependency("string_builder", dep_opts).module("string_builder");

    _ = b.addModule("uuid", .{
        .root_source_file = b.path("src/UUID.zig"),
        .imports = &.{.{ .name = "string_builder", .module = string_builder_module }},
    });

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/UUID.zig"),
        .target = target,
        .optimize = optimize,
    });

    // addLibs(lib_unit_tests, modules);
    lib_unit_tests.root_module.addImport("string_builder", string_builder_module);

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
