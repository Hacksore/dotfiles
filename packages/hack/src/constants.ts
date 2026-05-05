export const IMAGE_NAME = "hacksore/nvim";

export const CONTAINER_RUNTIMES = ["docker", "finch"] as const;
export type ContainerRuntime = (typeof CONTAINER_RUNTIMES)[number];
export const DEFAULT_CONTAINER_RUNTIME: ContainerRuntime = "docker";

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
