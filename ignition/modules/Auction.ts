import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const AuctionModule = buildModule("AuctionModule", (m) => {

  const duration = 3600n;

  const auction = m.contract("SecureAuction", [duration]);

  return { auction };

});

export default AuctionModule;