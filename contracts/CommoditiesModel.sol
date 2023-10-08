// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol"; 

contract CommoditiesModel is Context,ERC20,Ownable{
    mapping(address => uint256) public validators;

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
        require(validators[_validator] >= 0, "Commodities: you are not a validator");
        _;
    }
    
    constructor(string memory _name, string memory _symbol, uint256 initialSupply) ERC20 (_name,_symbol){
        _mint(msg.sender, initialSupply);
    }

    function addValidator(address _validator) public onlyOwner{
        validators[_validator] = 0;
        emit ValidatorAdded(_validator);
    }

    function removeValidator(address _validator) public onlyOwner{
        require(validators[_validator] <=0 , "Commodities: you can't remove a validator with tokens assigned");
        delete validators[_validator];
        emit ValidatorRemoved(_validator);
    }

    function redeemToken(address _account, uint256 _amount) public isValidator(_msgSender()){
        address spender = _msgSender();
        require(validators[spender]>=_amount, "Commodities: you don't have enough tokens to redeem");
        _spendAllowance(_account, spender, _amount);
        _burn(_account, _amount);
        validators[spender] -= _amount;
        emit TokenRedeemed(_account, spender, _amount);
    }

    function createToken(address _account, uint256 _amount) public isValidator(_msgSender()){
        require(_account != address(0), "ERC20: mint to the zero address");
        validators[msg.sender] += _amount;
        _mint(_account, _amount);
        emit TokenCreated(_account, _amount);
    }
}