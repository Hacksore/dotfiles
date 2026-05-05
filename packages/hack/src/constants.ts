export const IMAGE_NAME = "hacksore/nvim";
export const CONTAINER_PLATFORM = "linux/amd64";
const [CONTAINER_OS, CONTAINER_ARCH] = CONTAINER_PLATFORM.split("/");
const DEFAULT_APPLE_CONTAINER_MEMORY = "8g";
const DEFAULT_APPLE_CONTAINER_CPUS = "4";

export const CONTAINER_RUNTIMES = ["docker", "finch", "container"] as const;
export type ContainerRuntime = (typeof CONTAINER_RUNTIMES)[number];
export const DEFAULT_CONTAINER_RUNTIME: ContainerRuntime = "docker";

const CONTAINER_RUNTIME_DISPLAY_NAMES: Record<ContainerRuntime, string> = {
  docker: "Docker",
  finch: "Finch",
  container: "Apple container",
};

export function resolveContainerRuntime(
  runtime = process.env.HACK_CONTAINER_RUNTIME ?? DEFAULT_CONTAINER_RUNTIME,
): ContainerRuntime {
  if (CONTAINER_RUNTIMES.includes(runtime as ContainerRuntime)) {
    return runtime as ContainerRuntime;
  }

  throw new Error(
    `Unsupported container runtime "${runtime}". Expected one of: ${CONTAINER_RUNTIMES.join(", ")}`,
  );
}

export function getContainerRuntimeDisplayName(
  runtime: ContainerRuntime,
): string {
  return CONTAINER_RUNTIME_DISPLAY_NAMES[runtime];
}

export function getContainerBuildCommand(runtime: ContainerRuntime): string {
  if (runtime === "container") {
    return `${runtime} build --os ${CONTAINER_OS} --arch ${CONTAINER_ARCH} --tag ${IMAGE_NAME} .`;
  }

  return `${runtime} build --platform ${CONTAINER_PLATFORM} . -t ${IMAGE_NAME}`;
}

export function getContainerRunCommand(
  runtime: ContainerRuntime,
  args: string[],
): string {
  const testArgs = args.join(" ");

  if (runtime === "container") {
    const memory =
      process.env.HACK_APPLE_CONTAINER_MEMORY ?? DEFAULT_APPLE_CONTAINER_MEMORY;
    const cpus =
      process.env.HACK_APPLE_CONTAINER_CPUS ?? DEFAULT_APPLE_CONTAINER_CPUS;

    return [
      runtime,
      "run",
      "-e CI=1",
      "-e HACK_CONTAINER=1",
      `--os ${CONTAINER_OS}`,
      `--arch ${CONTAINER_ARCH}`,
      `--memory ${memory}`,
      `--cpus ${cpus}`,
      "--rm",
      IMAGE_NAME,
      testArgs,
    ]
      .filter(Boolean)
      .join(" ");
  }

  return [
    runtime,
    "run",
    "-e CI=1",
    "-e HACK_CONTAINER=1",
    "--rm",
    IMAGE_NAME,
    testArgs,
  ]
    .filter(Boolean)
    .join(" ");
}
