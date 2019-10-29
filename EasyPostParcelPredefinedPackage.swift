//
//  EasyPostParcelPredefinedPackage.swift
//  EasyPostApi
//
//  Created by William Welbes on 10/29/19.
//

import Foundation

public enum EasyPostParcelPredefinedPackageType: String {
    case card = "Card"
    case letter = "Letter"
    case flat = "Flat"
    case flatRateEnvelope = "FlatRateEnvelope"
    case smallFlatRateEnvelope = "SmallFlatRateEnvelope"
    case flatRateLegalEnvelope = "FlatRateLegalEnvelope"
    case flatRatePaddedEnvelope = "FlatRatePaddedEnvelope"
    case flatRateGiftCardEnvelope = "FlatRateGiftCardEnvelope"
    case flatRateWindowEnvelope = "FlatRateWindowEnvelope"
    case parcel = "Parcel"
    case irregularParcel = "IrregularParcel"
    case softPack = "SoftPack"
    case smallFlatRateBox = "SmallFlatRateBox"
    case mediumFlatRateBox = "MediumFlatRateBox"
    case largeFlatRateBox = "LargeFlatRateBox"
    case largeFlatRateBoxAPOFPO = "LargeFlatRateBoxAPOFPO"
    case largeFlatRateBoardGameBox = "LargeFlatRateBoardGameBox"
    case regionalRateBoxA = "RegionalRateBoxA"
    case regionalRateBoxB = "RegionalRateBoxB"
}

public struct EasyPostParcelPredefinedPackage {
    public let type: EasyPostParcelPredefinedPackageType
    public let typeDescription: String
    public let sizeDescription: String
}

public let easyPostParcelPredefinedPackages = [
    EasyPostParcelPredefinedPackage(type: .card, typeDescription: "Card", sizeDescription: ""),
    EasyPostParcelPredefinedPackage(type: .letter, typeDescription: "Letter", sizeDescription: ""),
    EasyPostParcelPredefinedPackage(type: .flat, typeDescription: "Flat", sizeDescription: ""),
    EasyPostParcelPredefinedPackage(type: .flatRateEnvelope, typeDescription: "Flat Rate Envelope", sizeDescription: "12 1/2\" x 9 1/2\""),
    EasyPostParcelPredefinedPackage(type: .smallFlatRateEnvelope, typeDescription: "Small Flat Rate Envelope", sizeDescription: "10\" x 6\""),
    EasyPostParcelPredefinedPackage(type: .flatRateLegalEnvelope, typeDescription: "Flat Rate Legal Envelope", sizeDescription: "15\" x 9 1/2\""),
    EasyPostParcelPredefinedPackage(type: .flatRatePaddedEnvelope, typeDescription: "Flat Rate Padded Envelope", sizeDescription: "12 1/2\" x 9 1/2\""),
    EasyPostParcelPredefinedPackage(type: .flatRateWindowEnvelope, typeDescription: "Flat Rate Window Envelope", sizeDescription: "10\" x 6\""),
    EasyPostParcelPredefinedPackage(type: .flatRateGiftCardEnvelope, typeDescription: "Flat Rate Gift Card Envelope", sizeDescription: "10\" x 7\""),
    EasyPostParcelPredefinedPackage(type: .parcel, typeDescription: "Parcel", sizeDescription: ""),
    EasyPostParcelPredefinedPackage(type: .irregularParcel, typeDescription: "Irregular Parcel", sizeDescription: ""),
    EasyPostParcelPredefinedPackage(type: .softPack, typeDescription: "Soft Pack", sizeDescription: ""),
    EasyPostParcelPredefinedPackage(type: .smallFlatRateBox, typeDescription: "Small Flat Rate Box", sizeDescription: "8 11/16\" x 5 7/16\" x 1 3/4\""),
    EasyPostParcelPredefinedPackage(type: .mediumFlatRateBox, typeDescription: "Medium Flat Rate Box", sizeDescription: "11 1/4\" x 8 3/4\" x 6\" or 14\" x 12\" x 3 1/2\""),
    EasyPostParcelPredefinedPackage(type: .largeFlatRateBox, typeDescription: "Large Flat Rate Box", sizeDescription: "12-1/4\" x 12-1/4\" x 6\" or 24-1/16\" x 11-7/8\" x 3-1/8\""),
    EasyPostParcelPredefinedPackage(type: .largeFlatRateBoxAPOFPO, typeDescription: "Large Flat Rate Box APO/FPO", sizeDescription: "12-1/4\" x 12-1/4\" x 6\""),
    EasyPostParcelPredefinedPackage(type: .largeFlatRateBoardGameBox, typeDescription: "Large Board Game Box", sizeDescription: "23 11/16\" x 11 3/4\" x 3\""),
    EasyPostParcelPredefinedPackage(type: .regionalRateBoxA, typeDescription: "Regional Rate Box A", sizeDescription: ""),
    EasyPostParcelPredefinedPackage(type: .regionalRateBoxB, typeDescription: "Regional Rate Box B", sizeDescription: ""),
]
