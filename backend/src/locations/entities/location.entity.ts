import {
    Entity,
    Column,
    PrimaryGeneratedColumn,
    Tree,
    TreeChildren,
    TreeParent,
    Index,
} from 'typeorm';
import { LocationLevel } from './location-level.enum';

@Entity('location')
@Tree('materialized-path') // Optimized tree structure for fast queries
export class Location {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Index()
    @Column({ unique: true, length: 10 })
    code: string; // Official administrative code (e.g., "01", "001", "00001")

    @Column({ length: 100 })
    name: string;

    @Column({ name: 'name_en', length: 100, nullable: true })
    nameEn?: string;

    @Column({ name: 'full_name', length: 150 })
    fullName: string;

    @Column({ name: 'full_name_en', length: 150, nullable: true })
    fullNameEn?: string;

    @Column({ name: 'code_name', length: 100, nullable: true })
    codeName?: string;

    @Column({
        type: 'enum',
        enum: LocationLevel,
    })
    level: LocationLevel; // PROVINCE, DISTRICT, or WARD

    @TreeChildren()
    children: Location[]; // Child locations (e.g., Province -> Districts)

    @TreeParent()
    parent: Location | null; // Parent location (e.g., District -> Province)
}
