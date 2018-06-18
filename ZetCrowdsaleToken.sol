pragma solidity ^0.4.23;

import "./MintableToken.sol";

contract ZetCrowdsaleToken is MintableToken {

  // solium-disable-next-line uppercase
  string public constant name = "ZL Crowdsale Token";
  string public constant symbol = "ZLCT"; // solium-disable-line uppercase
  uint8 public constant decimals = 18; // solium-disable-line uppercase

}