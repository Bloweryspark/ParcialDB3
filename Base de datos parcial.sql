-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ExamDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ExamDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ExamDB` DEFAULT CHARACTER SET utf8 ;
USE `ExamDB` ;

-- -----------------------------------------------------
-- Table `ExamDB`.`Players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExamDB`.`Players` (
  `idPlayers` INT NOT NULL,
  `User` VARCHAR(45) NOT NULL,
  `PlayedTime` VARCHAR(45) NOT NULL,
  `FireFrecuency` VARCHAR(45) NOT NULL,
  `DeadCount` VARCHAR(45) NOT NULL,
  `KillCount` VARCHAR(45) NOT NULL,
  `KillRatio` VARCHAR(45) NOT NULL,
  `Money` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPlayers`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ExamDB`.`Lobby`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExamDB`.`Lobby` (
  `idLobby` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `ActivePlayers` VARCHAR(450) NOT NULL,
  `ActiveTime` VARCHAR(45) NOT NULL,
  `Location` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idLobby`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ExamDB`.`Items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExamDB`.`Items` (
  `idItems` INT NOT NULL,
  `SafeHouse` VARCHAR(45) NULL,
  `Vehicle` VARCHAR(45) NULL,
  `SpecialItem` VARCHAR(45) NULL,
  `Players_idPlayers` INT NOT NULL,
  PRIMARY KEY (`idItems`),
  INDEX `fk_Items_Players1_idx` (`Players_idPlayers` ASC) VISIBLE,
  CONSTRAINT `fk_Items_Players1`
    FOREIGN KEY (`Players_idPlayers`)
    REFERENCES `ExamDB`.`Players` (`idPlayers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ExamDB`.`Reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExamDB`.`Reports` (
  `idReports` INT NOT NULL,
  `Reporter` VARCHAR(45) NOT NULL,
  `Reported` VARCHAR(45) NOT NULL,
  `Reason` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idReports`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ExamDB`.`Lobby_has_Players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExamDB`.`Lobby_has_Players` (
  `Lobby_idLobby` INT NOT NULL,
  `Players_idPlayers` INT NOT NULL,
  PRIMARY KEY (`Lobby_idLobby`, `Players_idPlayers`),
  INDEX `fk_Lobby_has_Players_Players1_idx` (`Players_idPlayers` ASC) VISIBLE,
  INDEX `fk_Lobby_has_Players_Lobby_idx` (`Lobby_idLobby` ASC) VISIBLE,
  CONSTRAINT `fk_Lobby_has_Players_Lobby`
    FOREIGN KEY (`Lobby_idLobby`)
    REFERENCES `ExamDB`.`Lobby` (`idLobby`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lobby_has_Players_Players1`
    FOREIGN KEY (`Players_idPlayers`)
    REFERENCES `ExamDB`.`Players` (`idPlayers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ExamDB`.`Lobby_has_Reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ExamDB`.`Lobby_has_Reports` (
  `Lobby_idLobby` INT NOT NULL,
  `Reports_idReports` INT NOT NULL,
  PRIMARY KEY (`Lobby_idLobby`, `Reports_idReports`),
  INDEX `fk_Lobby_has_Reports_Reports1_idx` (`Reports_idReports` ASC) VISIBLE,
  INDEX `fk_Lobby_has_Reports_Lobby1_idx` (`Lobby_idLobby` ASC) VISIBLE,
  CONSTRAINT `fk_Lobby_has_Reports_Lobby1`
    FOREIGN KEY (`Lobby_idLobby`)
    REFERENCES `ExamDB`.`Lobby` (`idLobby`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lobby_has_Reports_Reports1`
    FOREIGN KEY (`Reports_idReports`)
    REFERENCES `ExamDB`.`Reports` (`idReports`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
