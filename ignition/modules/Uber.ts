import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("UberModule", (m) => {
  const uber = m.contract("Uber");
  return { uber };
});