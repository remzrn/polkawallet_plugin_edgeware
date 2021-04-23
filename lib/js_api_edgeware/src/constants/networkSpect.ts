import networks from "@polkadot/networks";
import { assert } from "@polkadot/util";

const colors = {
  background: {
    app: "#151515",
    button: "C0C0C0",
    card: "#262626",
    os: "#000000",
  },
  border: {
    dark: "#000000",
    light: "#666666",
    signal: "#8E1F40",
  },
  signal: {
    error: "#D73400",
    main: "#FF4077",
  },
  text: {
    faded: "#9A9A9A",
    main: "#C0C0C0",
  },
};

export const unknownNetworkPathId = "";

export const NetworkProtocols = Object.freeze({
  ETHEREUM: "ethereum",
  SUBSTRATE: "substrate",
  UNKNOWN: "unknown",
});

// accounts for which the network couldn't be found (failed migration, removed network)
export const UnknownNetworkKeys = Object.freeze({
  UNKNOWN: "unknown",
});

// genesisHash is used as Network key for Substrate networks
export const SubstrateNetworkKeys = Object.freeze({
  EDGEWARE: "0x742a2ca70c2fda6cee4f8df98d64c4c670a052d9568058982dad9d5a7a135c5b", // https://polkascan.io/pre/edgeware/block/0
});

const unknownNetworkBase = {
  [UnknownNetworkKeys.UNKNOWN]: {
    color: colors.signal.error,
    order: 99,
    pathId: unknownNetworkPathId,
    prefix: 2,
    protocol: NetworkProtocols.UNKNOWN,
    secondaryColor: colors.background.card,
    title: "Unknown network",
  },
};

const substrateNetworkBase = {
  [SubstrateNetworkKeys.EDGEWARE]: {
    color: "#0B95E0",
    decimals: 18,
    genesisHash: SubstrateNetworkKeys.EDGEWARE,
    order: 4,
    pathId: "edgeware",
    prefix: 7,
    title: "Edgeware",
    unit: "EDG",
  },
};

const substrateDefaultValues = {
  color: "#4C4646",
  protocol: NetworkProtocols.SUBSTRATE,
  secondaryColor: colors.background.card,
};

function setDefault(networkBase, defaultProps) {
  return Object.keys(networkBase).reduce((acc, networkKey) => {
    return {
      ...acc,
      [networkKey]: {
        ...defaultProps,
        ...networkBase[networkKey],
      },
    };
  }, {});
}

export const SUBSTRATE_NETWORK_LIST = Object.freeze(setDefault(substrateNetworkBase, substrateDefaultValues));
export const UNKNOWN_NETWORK = Object.freeze(unknownNetworkBase);

const substrateNetworkMetas = Object.values({
  ...SUBSTRATE_NETWORK_LIST,
  ...UNKNOWN_NETWORK,
});

export const PATH_IDS_LIST = substrateNetworkMetas.map((meta: any) => meta.pathId);

export const NETWORK_LIST = Object.freeze(Object.assign({}, SUBSTRATE_NETWORK_LIST, [], UNKNOWN_NETWORK));

export const defaultNetworkKey = SubstrateNetworkKeys.EDGEWARE;

function getGenesis(name: string): string {
  const network = networks.find(({ network }) => network === name);
  assert(network && network.genesisHash[0], `Unable to find genesisHash for ${name}`);
  return network.genesisHash[0];
}
export const EDGEWARE_GENESIS = getGenesis("edgeware");