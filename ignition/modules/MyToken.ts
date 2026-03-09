import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const MyTokenModule = buildModule("MyTokenModule", (m) => {

  const initialSupply = 1000000n * 10n ** 18n;

  const token = m.contract("MyToken", [initialSupply]);

  return { token };

});

export default MyTokenModule;