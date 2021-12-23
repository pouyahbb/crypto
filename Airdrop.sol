pragma solidity >=0.7.0;
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Token.sol";


contract Airdrop is Ownable {
    using SafeMath for uint;

    address public tokenAddr;

    event BSCTransfer(address beneficiary, uint amount);

    constructor(address _tokenAddr) public {
        tokenAddr = _tokenAddr;
    }

    function dropTokens(address[] memory _recipients, uint256 _amount) public onlyOwner returns (bool) {
       
        for (uint i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0));
            require(Token(tokenAddr).transfer(_recipients[i], _amount));
        }

        return true;
    }

    function dropBSC(address[] memory _recipients, uint256[] memory _amount) public payable onlyOwner returns (bool) {
        uint total = 0;

        for(uint j = 0; j < _amount.length; j++) {
            total = total.add(_amount[j]);
        }

        require(total <= msg.value);
        require(_recipients.length == _amount.length);


        for (uint i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0));

            payable(_recipients[i]).transfer(_amount[i]);

            emit BSCTransfer(_recipients[i], _amount[i]);
        }

        return true;
    }

    function updateTokenAddress(address newTokenAddr) public onlyOwner {
        tokenAddr = newTokenAddr;
    }

    function withdrawTokens(address beneficiary) public onlyOwner {
        require(Token(tokenAddr).transfer(beneficiary, Token(tokenAddr).balanceOf(address(this))));
    }

    function withdrawBSC(address payable beneficiary) public onlyOwner {
        beneficiary.transfer(address(this).balance);
    }
}