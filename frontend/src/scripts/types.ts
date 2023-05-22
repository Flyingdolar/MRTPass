export enum Role {
  "user",
  "admin",
  "PROGRAMMANAGER",
  "REVIEWER",
}
export interface User {
  id: number;
  account: string;
  password: string;
  nickname: string;
  role: Role;
  picture: null;
}
