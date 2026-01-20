import { Audit, AUDIT_ACTION_KEY, AUDIT_TARGET_ENTITY_KEY } from './audit.decorator';
import { Reflector } from '@nestjs/core';

describe('Audit Decorator', () => {
    class TestClass {
        @Audit('CREATE', 'USER')
        testMethod() { }
    }

    const reflector = new Reflector();

    it('should set audit action metadata', () => {
        const action = reflector.get(AUDIT_ACTION_KEY, TestClass.prototype.testMethod);
        expect(action).toBe('CREATE');
    });

    it('should set audit target entity metadata', () => {
        const targetEntity = reflector.get(AUDIT_TARGET_ENTITY_KEY, TestClass.prototype.testMethod);
        expect(targetEntity).toBe('USER');
    });
});
