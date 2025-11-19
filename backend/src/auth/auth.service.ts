import { Inject, Injectable } from "@nestjs/common";

@Injectable()
export class AuthService {
    register() {
        return "User registered successfully";
    }
}