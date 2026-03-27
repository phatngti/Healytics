export enum BusinessType {
    MASSAGE_THERAPY = 'MASSAGE_THERAPY',           // Massage Thư giãn
    MASSAGE_REHABILITATION = 'MASSAGE_REHABILITATION', // Massage Trị liệu
    SPA_BEAUTY = 'SPA_BEAUTY',                    // Spa & Làm đẹp
    FITNESS = 'FITNESS',                           // Thể hình (Gym/Yoga)
    PHARMACY = 'PHARMACY',                         // Dược phẩm
    DENTAL = 'DENTAL',                             // Nha khoa
    TRADITIONAL_MEDICINE = 'TRADITIONAL_MEDICINE', // Đông y
    PSYCHOLOGY = 'PSYCHOLOGY',                     // Tâm lý & Trị liệu
    DERMATOLOGY = 'DERMATOLOGY',                   // Da liễu & Thẩm mỹ
    NUTRITION = 'NUTRITION',                       // Dinh dưỡng
    PSYCHIATRY = 'PSYCHIATRY',                     // Tâm thần học
}

export const bussinessServices = new Map<BusinessType, { label: string; value: BusinessType; description: string }>([
    [BusinessType.MASSAGE_THERAPY, { label: 'Massage Therapy', value: BusinessType.MASSAGE_THERAPY, description: 'Massage Thư giãn' }],
    [BusinessType.MASSAGE_REHABILITATION, { label: 'Rehabilitation Massage', value: BusinessType.MASSAGE_REHABILITATION, description: 'Massage Trị liệu' }],
    [BusinessType.SPA_BEAUTY, { label: 'Spa & Beauty', value: BusinessType.SPA_BEAUTY, description: 'Spa & Làm đẹp' }],
    [BusinessType.FITNESS, { label: 'Fitness (Gym/Yoga)', value: BusinessType.FITNESS, description: 'Thể hình (Gym/Yoga)' }],
    [BusinessType.PHARMACY, { label: 'Pharmacy', value: BusinessType.PHARMACY, description: 'Dược phẩm' }],
    [BusinessType.DENTAL, { label: 'Dental', value: BusinessType.DENTAL, description: 'Nha khoa' }],
    [BusinessType.TRADITIONAL_MEDICINE, { label: 'Traditional Medicine', value: BusinessType.TRADITIONAL_MEDICINE, description: 'Đông y' }],
    [BusinessType.PSYCHOLOGY, { label: 'Psychology & Therapy', value: BusinessType.PSYCHOLOGY, description: 'Tâm lý & Trị liệu' }],
    [BusinessType.DERMATOLOGY, { label: 'Dermatology & Aesthetics', value: BusinessType.DERMATOLOGY, description: 'Da liễu & Thẩm mỹ' }],
    [BusinessType.NUTRITION, { label: 'Nutrition', value: BusinessType.NUTRITION, description: 'Dinh dưỡng' }],
    [BusinessType.PSYCHIATRY, { label: 'Psychiatry', value: BusinessType.PSYCHIATRY, description: 'Tâm thần học' }],
    ]);
