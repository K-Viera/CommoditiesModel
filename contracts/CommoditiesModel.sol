// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol"; 

contract CommoditiesModel is Context,ERC20,Ownable{
    mapping(address => uint256) private _validatorsBalance;
    mapping(address => bool) private _validators; 
    
    function validatorBalanceOf(address validator) public view returns (uint256) {
        return _validatorsBalance[validator];
    }

    function validatorStatusOf(address validator) public view returns (bool) {
        return _validators[validator];
    }

    constructor(string memory _name, string memory _symbol, uint256 initialSupply) ERC20 (_name,_symbol){
        _mint(msg.sender, initialSupply);
    }
    // Definir un evento para registrar cuando se añade un validador
    event ValidatorAdded(address indexed validator);

    // Definir un evento para registrar cuando se elimina un validador
    event ValidatorRemoved(address indexed validator);
    
    // Definir un evento para registrar cuando se canjea un token
    event TokenRedeemed(address indexed account, address indexed spender, uint256 amount);

    // Definir un evento para registrar cuando se crea un token
    event TokenCreated(address indexed account, uint256 amount);

    //Verifica que el address exista en el mapping validators
    modifier isValidator(address _validator){
        require(_validators[_validator] == true, "Commodities: you are not a validator");
        _;
    }
    
    function addValidator(address _validator) public onlyOwner{
        _validators[_validator] = true;
        emit ValidatorAdded(_validator);
    }

    function removeValidator(address _validator) public onlyOwner{
        require(_validatorsBalance[_validator] <=0 , "Commodities: you can't remove a validator with tokens assigned");
        _validators[_validator] = false;
        emit ValidatorRemoved(_validator);
    }

    function redeemTokens(address _account, uint256 _amount) public isValidator(_msgSender()){
        address spender = _msgSender();
        require(_validatorsBalance[spender]>=_amount, "Commodities: you don't have enough tokens to redeem");
        _spendAllowance(_account, spender, _amount);
        _burn(_account, _amount);
        _validatorsBalance[spender] -= _amount;
        emit TokenRedeemed(_account, spender, _amount);
    }

    function createTokens(address _account, uint256 _amount) public isValidator(_msgSender()){
        require(_account != address(0), "ERC20: mint to the zero address");
        _validatorsBalance[msg.sender] += _amount;
        _mint(_account, _amount);
        emit TokenCreated(_account, _amount);
    }
}