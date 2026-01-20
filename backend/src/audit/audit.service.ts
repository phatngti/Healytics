import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditLog } from './entities/audit-log.entity';
import { CreateAuditLogDto } from './dto/create-audit-log.dto';

@Injectable()
export class AuditService {
    constructor(
        @InjectRepository(AuditLog)
        private readonly auditLogRepo: Repository<AuditLog>,
    ) { }

    async logAction(dto: CreateAuditLogDto): Promise<AuditLog> {
        const log = this.auditLogRepo.create(dto);
        return this.auditLogRepo.save(log);
    }

    async findAll(query: any): Promise<AuditLog[]> {
        const qb = this.auditLogRepo.createQueryBuilder('audit');

        if (query.targetId) {
            qb.andWhere('audit.targetId = :targetId', { targetId: query.targetId });
        }

        if (query.actorId) {
            qb.andWhere('audit.actorId = :actorId', { actorId: query.actorId });
        }

        if (query.action) {
            qb.andWhere('audit.action = :action', { action: query.action });
        }

        qb.orderBy('audit.createdAt', 'DESC');

        return qb.getMany();
    }

    async getLogsByTarget(targetId: string): Promise<AuditLog[]> {
        return this.auditLogRepo.find({
            where: { targetId },
            order: { createdAt: 'DESC' },
        });
    }

}
