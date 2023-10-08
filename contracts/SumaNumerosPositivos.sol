// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//Contrato
contract SumaNumerosPositivos {
    //Variables
    uint256 public resultado;

    //Constructor
    constructor() {resultado = 0;}

    //Modificadores
    modifier soloNumerosPositivos(uint256 num1, uint256 num2) {
        require(num1 > 0 && num2 > 0, "Los numeros deben ser mayores a 0");
        _;
    }

    //Funciones
    function sumarNumeros(uint256 num1, uint256 num2) public soloNumerosPositivos(num1, num2)
    { resultado = num1 + num2;}
}

