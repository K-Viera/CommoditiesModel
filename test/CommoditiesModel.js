const { expect } = require("chai");
const { ethers } = require('hardhat');

describe("CommoditiesModel contract", function () {
    let owner;
    let validator;
    let user;
    let commodities;

    beforeEach(async () => {
        [owner, validator, user] = await ethers.getSigners();

        const CommoditiesModel = await ethers.getContractFactory("CommoditiesModel");
        commodities = await CommoditiesModel.deploy("Commodities", "COM", 0);
    });

    describe("Deployment tests", function () {
        it("should deploy with the correct name, symbol, and initial supply", async function () {
            expect(await commodities.name()).to.equal("Commodities");
            expect(await commodities.symbol()).to.equal("COM");
            expect(await commodities.totalSupply()).to.equal(0); // Adjust the initial supply accordingly
        });

    });

    describe("Validators tests", function () {
        it("should allow owner to add new validators", async function () {
            await commodities.addValidator(validator.address);
            expect(await commodities.validatorStatusOf(validator.address)).to.equal(true);
        });

        it("shouls allow owner to remove validators", async function () {
            await commodities.addValidator(validator.address);
            await commodities.removeValidator(validator.address);
            expect(await commodities.validatorStatusOf(validator.address)).to.equal(false);
        });
    });

    describe("Tokens creations tests", function () {
        it("should allow validator to create tokens", async function () {
            await commodities.addValidator(validator.address);
            await commodities.connect(validator).createTokens(user.address, 100);
            expect(await commodities.balanceOf(user.address)).to.equal(100);
            expect(await commodities.validatorBalanceOf(validator.address)).to.equal(100);
            expect(await commodities.totalSupply()).to.equal(100);
        });

        it("should not allow non-validator to create tokens", async function () {
            expect(await commodities.validatorStatusOf(validator.address)).to.equal(false);
            await expect(commodities.connect(validator).createTokens(user.address, 100)).to.be.revertedWith("Commodities: you are not a validator");
        });
    });

    describe("Tokens redeem", function () {

        it("should not allow validator to redeem tokens from a non-aprove account", async function () {
            await commodities.addValidator(validator.address);
            await commodities.connect(validator).createTokens(user.address, 100);
            await expect(commodities.connect(validator).redeemTokens(user.address, 10)).to.be.revertedWith("ERC20: insufficient allowance");
        });

        it("should allow validator to redeem tokens from an approved account", async function () {
            await commodities.addValidator(validator.address);
            await commodities.connect(validator).createTokens(user.address, 100);
            await commodities.connect(user).approve(validator.address, 100);
            await commodities.connect(validator).redeemTokens(user.address, 10);
            expect(await commodities.balanceOf(user.address)).to.equal(90);
            expect(await commodities.validatorBalanceOf(validator.address)).to.equal(90);
            expect(await commodities.totalSupply()).to.equal(90);
        });

        it("should not allow validator to redeem tokens from an approved account if the validator does not have enough tokens", async function () {
            await commodities.addValidator(validator.address);
            await commodities.connect(validator).createTokens(user.address, 100);
            await commodities.connect(user).approve(validator.address, 110);
            await expect(commodities.connect(validator).redeemTokens(user.address, 101)).to.be.revertedWith("Commodities: you don't have enough tokens to redeem");
        });

        it("should not allow validator to redeem tokens from an approved account if the account does not have enough tokens", async function () {
            await commodities.addValidator(validator.address);
            await commodities.connect(validator).createTokens(user.address, 200);
            await commodities.connect(user).approve(validator.address, 100);
            await expect(commodities.connect(validator).redeemTokens(user.address, 101)).to.be.revertedWith("ERC20: insufficient allowance");
        });
    });

});