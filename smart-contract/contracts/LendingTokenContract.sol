// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;
import "./ERC20Interface.sol";

contract LendingTokenContract is ERC20Interface {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint8 public decimals;
    address public owner;

    mapping(address => uint256) private tokenBalances;
    mapping(address => mapping(address => uint256)) public allowed;

    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) {
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
        totalSupply = _initialAmount * (10 ** uint256(decimals));
        tokenBalances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * @notice Send "_value" token to "_to" from "msg.sender"
     * @param _to The address of recipient
     * @param _value The amount of token to be transferred
     * @return success wheater the transfer was successful or not
     */
    function transfer(
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        require(tokenBalances[msg.sender] >= _value, "insufficient funds");

        // Transfer Amount
        tokenBalances[msg.sender] = tokenBalances[msg.sender] - (_value);
        tokenBalances[_to] = tokenBalances[_to] + (_value);

        // Emit event
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @param _owner The address from which the balance will be retrived
     * @return balance The balance
     */
    function balanceOf(
        address _owner
    ) public view override returns (uint256 balance) {
        return tokenBalances[_owner];
    }

    /**
     * @notice Send "_value" token to "_to" from "_from" on the condition it is approved by "_from"
     * @param _from The address of the sender
     * @param _to The address of the receiver
     * @param _value The amount of the token to be transferred
     * @return success Whether the transfer was successful or not
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        // Check Balance
        require(allowance(_from, msg.sender) >= _value, "insufficient balance");
        require(tokenBalances[_from] >= _value, "invalid transfer amount");

        // transfer amount
        tokenBalances[_to] = tokenBalances[_to] + _value;
        tokenBalances[_from] = tokenBalances[_from] - _value;
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;

        // Emit Event
        emit Transfer(_from, _to, _value);

        return true;
    }

    /**
     * @notice "msg.sender" approves "_spender" to spend "_value" tokens
     * @param _spender The address of the account able to transfer tokens
     * @param _value The amount of tokens to be approved for transfer
     * @return success Whether the approval was successful or not
     */
    function approve(
        address _spender,
        uint256 _value
    ) public override returns (bool success) {
        // Check approval
        require(balanceOf(msg.sender) >= _value, "insufficient balance");

        //Provide approval
        allowed[msg.sender][_spender] = _value;

        // Emit Event
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @param _owner The address of the account owning tokens
     * @param _spender The address of the account able to transfer tokens
     * @return remaining Amount of remaining tokens allowed to spent
     */
    function allowance(
        address _owner,
        address _spender
    ) public view override returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}
