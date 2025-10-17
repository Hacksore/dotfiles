import { IMAGE_NAME } from "../constants.ts";
import { parseFlagToBoolean, runCommand } from "../utils.ts";

export async function handleTest(options: {
  nightly: boolean;
  frozenLock: boolean;
  remote: boolean;
  skipCargo: boolean;
}) {
  const { nightly, frozenLock, remote, skipCargo } = options;
  const frozenLockfile = parseFlagToBoolean(frozenLock) ? "1" : "0";
  const useLocal = remote ? "0" : "1";
  const useCargo = parseFlagToBoolean(skipCargo) ? "1" : "0";
  const selectedChannel = nightly ? "nightly" : "stable";

  console.log(options)

  try {

    // TODO: i hate that we nave to use env vars to pass args to docker
    // we could pass to stdin but that would be more complex to handle
    const envVars = {
      SKIP_CARGO: useCargo,
      LOCAL: useLocal,
      FROZEN_LOCKFILE: frozenLockfile,
    };

    const envString = Object.entries(envVars)
      .map(([key, value]) => `-e ${key}=${value}`)
      .join(" ");

    await runCommand(
      `docker run ${envString} --rm ${IMAGE_NAME} ${selectedChannel}`,
    );
  } catch (error) {
    console.error("Test failed:", error.message);
    process.exit(1);
  }
}
