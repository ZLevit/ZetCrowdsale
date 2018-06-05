pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./CappedCrowdsale.sol";
import "./MintedCrowdsale.sol";
import "./TimedCrowdsale.sol";
import "./RefundableCrowdsale.sol";
import "./MintableToken.sol";
import "./DateTime.sol";

/**
 * @title ZKeyCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract ZKeyCrowdsaleToken is MintableToken {

  // solium-disable-next-line uppercase
  string public constant name = "ZY Crowdsale Token";
  string public constant symbol = "ZYCT"; // solium-disable-line uppercase
  uint8 public constant decimals = 18; // solium-disable-line uppercase

}

  

/**
 * @title ZKeyCrowdsaleBase
 * @dev This is an example of a fully fledged crowdsale.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 *
 * Crowdsale - base implementation
 * CappedCrowdsale - sets a max boundary for raised funds
 * TimedCrowdsale - sets start /stop time for sale 
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
// XXX There doesn't seem to be a way to split this line that keeps solium
// happy. See:
// https://github.com/duaraghav8/Solium/issues/205
// --elopio - 2018-05-10
// solium-disable-next-line max-len
contract ZKeyCrowdsaleBase is CappedCrowdsale/*, RefundableCrowdsale*/, FinalizableCrowdsale, MintedCrowdsale  {

  constructor(
    uint256 _openingTime,
    uint256 _closingTime,
    uint256 _rate,
    address _wallet,
    uint256 _cap,
    
    MintableToken _token
  )
    public
    Crowdsale(_rate, _wallet, _token)
    CappedCrowdsale(_cap)
    TimedCrowdsale(_openingTime, _closingTime)

  {
    //As goal needs to be met for a successful crowdsale
    //the value needs to less or equal than a cap which is limit for accepted funds
    require(_goal <= _cap);
  }
  
  uint256 public dbgWeiAmmount;
  uint256 public dbgWeiRaized;
  uint256 public dbgTokens;
  
  function buyTokens(address _beneficiary) public payable {

     uint256 weiAmount = msg.value;
     dbgWeiAmmount = weiAmount;
     
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);
    dbgTokens = tokens;
     
    // update state
    weiRaised = weiRaised.add(weiAmount);
    dbgWeiRaized = weiRaised;

    _processPurchase(_beneficiary, tokens);
    
    emit TokenPurchase(
      msg.sender,
      _beneficiary,
      weiAmount,
      tokens
    );

    _updatePurchasingState(_beneficiary, weiAmount);
    _forwardFunds();
    _postValidatePurchase(_beneficiary, weiAmount);

  }

}

/**
 * @title ZKeyCrowdsale
 */
contract ZKeyCrowdsale is ZKeyCrowdsaleBase {

/* Openning sale date */
    uint constant OPENNING_DAY = 20;
    uint constant OPENNING_MONTH = 5;
    uint constant OPENNING_YEAR  = 2018;
    /* converted using https://www.epochconverter.com/ */
    uint256 constant OPENNING_DT =1526774400;
    
/* Closing sale date */    
    uint constant CLOSING_DAY = 1;
    uint constant CLOSING_MONTH = 9;
    uint constant CLOSING_YEAR  = 2018;
    /* converted using https://www.epochconverter.com/ */
    uint256 constant CLOSING_DT =1535760000;
    
/* Rate xxxx Tokens = 1 WEI  */   
    uint256 constant TOKEN_RATE = 10;
    
    
/*   CAP -  maximum amount of wei accepted in the crowdsale. */
    uint256 constant WEI_CAP = 1000000000000000000;

  constructor(
    address _wallet
  )
  
  
  public 
  ZKeyCrowdsaleBase(OPENNING_DT,
                    CLOSING_DT,
                    TOKEN_RATE,
                    _wallet,
                    WEI_CAP,
                    new ZKeyCrowdsaleToken())
                    {}
}
  