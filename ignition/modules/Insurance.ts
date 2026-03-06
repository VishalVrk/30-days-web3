import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const InsuranceModule = buildModule("InsuranceModule", (m) => {

  const insurance = m.contract("Insurance");

  return { insurance };

});

export default InsuranceModule;