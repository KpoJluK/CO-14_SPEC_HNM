import * as gulp from "gulp";
import * as gulpReplace from "gulp-replace";
import * as gulpPbo from "gulp-armapbo";
import * as gulpZip from "gulp-zip";
import * as vinylPaths from "vinyl-paths";
import * as del from "del";

import { resolve } from "path";
import { readFileSync, lstatSync } from "fs";

import { MissionPaths } from "./toolchain";
import { Preset, FolderStructureInfo } from "./toolchain";
const jsonc = require("jsonc").safe;

const jsoncPresets: string = readFileSync("./missions.config.json").toString();
const [err, presets]: [any, Preset[]] = jsonc.parse(jsoncPresets);
if (err) {
    throw new Error(`Failed to parse JSON: ${err.message}`);
}

/**
 * Mission folders configuration
 */
const paths: FolderStructureInfo = {
    framework: [
        "./core",
        "./docs",
        "./modules",
        "init.sqf",
        "define_mod.sqf",
        "README.md",
        "stringtable.xml",
        "description.ext",
    ],
    missionsFolder: "./missions",
    workDir: "./dist",
};

/**
 * Create gulp tasks
 */
let taskNames: string[] = [];
let taskNamesPbo: string[] = [];
let taskNamesZip: string[] = [];

for (let preset of presets) {
    const mission = new MissionPaths(preset, paths);
    const taskName = [preset.missionName, preset.map].join(".");

    taskNames.push("mission_" + taskName);

    gulp.task(
        "mission_" + taskName,
        gulp.series(
            /** Copy mission framework to output dir */
            function copyFramework() {
                return gulp
                    .src(
                        mission.getFrameworkPath().map((v) => {
                            if (lstatSync(v).isDirectory()) {
                                return v.concat("/**/*");
                            }
                            return v;
                        }),
                        { base: "." }
                    )
                    .pipe(gulp.dest(mission.getOutputDir()));
            },

            /** Copy mission.sqm to output dir */
            function copyMissionSQM() {
                return gulp
                    .src(mission.getMissionSqmPath())
                    .pipe(gulp.dest(mission.getOutputDir()));
            },

            function copyMissionDef() {
                del.sync(`${mission.getOutputDir()}/core/def/**/*`, {
                    force: true,
                });
                return gulp
                    .src(mission.getMissionDefPath())
                    .pipe(gulp.dest(`${mission.getOutputDir()}/core/def`));
            }
        )
    );

    /**
     * Pack PBOs
     */
    taskNamesPbo.push("pack_" + taskName);

    gulp.task("pack_" + taskName, () => {
        return gulp
            .src(mission.getOutputDir() + "/**/*")
            .pipe(
                gulpPbo({
                    fileName: mission.getFullName() + ".pbo",
                    progress: false,
                    verbose: false,
                    // Do not compress (SLOW)
                    compress: true
                        ? []
                        : [
                              "core/img/",
                              "core/sounds/",
                              "**/*.sqf",
                              "mission.sqm",
                              "description.ext",
                          ],
                })
            )
            .pipe(gulp.dest(mission.getWorkDir() + "/pbo"));
    });

    /**
     * Create ZIP files
     */
    taskNamesZip.push("zip_" + taskName);

    gulp.task("zip_" + taskName, () => {
        return gulp
            .src(["./LICENSE", "./CHANGELOG.md", "./README.md"], {
                base: ".", // Change base dir to have correct relative paths in ZIP
            })
            .pipe(
                gulp.src(
                    resolve(
                        mission.getWorkDir(),
                        "pbo",
                        mission.getFullName() + ".pbo"
                    ),
                    {
                        base: resolve(mission.getWorkDir(), "pbo"), // Change base dir to have correct relative paths in ZIP
                    }
                )
            )
            .pipe(gulpZip(mission.getFullName() + ".zip"))
            .pipe(gulp.dest(mission.getWorkDir()));
    });
}

// Main tasks
gulp.task("clean", () => {
    return gulp.src(paths.workDir).pipe(vinylPaths(del));
});

gulp.task(
    "build",
    gulp.series(gulp.series(taskNames), (done) => {
        done();
    })
);

gulp.task("pbo", gulp.series(taskNamesPbo));

gulp.task("zip", gulp.series(taskNamesZip));

gulp.task("default", gulp.series(gulp.task("build"), gulp.task("pbo")));

gulp.task("dev", () => {
    const path = paths.framework.map((v) => resolve(v));
    gulp.watch(path, { usePolling: true, ignoreInitial: false }).on(
        "change",
        gulp.series("build")
    );
});
