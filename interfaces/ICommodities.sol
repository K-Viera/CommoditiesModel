// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ICommoditiesModel {
    /**
     * @dev Emitted when a new validator is added.
     */
    event ValidatorAdded(address indexed validator);

    /**
     * @dev Emitted when a validator is removed.
     */
    event ValidatorRemoved(address indexed validator);

    /**
     * @dev Emitted when a token is redeemed.
     */
    event TokenRedeemed(address indexed account, address indexed spender, uint256 amount);

    /**
     * @dev Emitted when a new token is created.
     */
    event TokenCreated(address indexed account, uint256 amount);

    /**
     * @dev Add a new validator to the contract.
     * @param _validator The address of the validator to be added.
     */
    function addValidator(address _validator) external returns (bool);

    /**
     * @dev Remove a validator from the contract.
     * @param _validator The address of the validator to be removed.
     */
    function removeValidator(address _validator) external returns (bool);

    /**
     * @dev Redeem tokens from a validator and remove tokens from account.
     * @param _account The address from which tokens will be redeemed.
     * @param _amount The amount of tokens to redeem.
     */
    function redeemToken(address _account, uint256 _amount) external returns (bool);

    /**
     * @dev Create new tokens and assign them to an address by a validator.
     * @param _account The address to which tokens will be created and assigned.
     * @param _amount The amount of tokens to create and assign.
     */
    function createToken(address _account, uint256 _amount) external returns (bool);

    /**
     * @dev Get the balance of tokens for a specific validator.
     * @param _validator The address of the validator.
     * @return The balance of tokens held by the validator.
     */
    function validators(address _validator) external view returns (uint256);
}