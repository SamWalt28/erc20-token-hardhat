// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./IERC20.sol";
import "hardhat/console.sol";

contract ShanCoin is IERC20 {

    string public constant name = "ShanCoin";
    string public constant symbol = "SHA";
    uint8 public constant decimals = 18;

    mapping(address => uint256) _balances;

    mapping(address => mapping (address => uint256)) private _allowances;
    
    uint256 private _totalSupply;

    constructor(uint256 total) {  
	    _totalSupply = total * 10 ** decimals;
	    _balances[msg.sender] = _totalSupply;
        console.log("Total supply created and assigned to Owner: ", _totalSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address recipient, uint amount) public override returns (bool) {
        _transfer(msg.sender,recipient,amount);
        return true;
    }


    function approve(address spender, uint amount) public override returns (bool) {
        _approve(msg.sender,spender,amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, msg.sender, currentAllowance - amount);
        }
        return true;
    }

    function _transfer(address sender,address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender,uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}