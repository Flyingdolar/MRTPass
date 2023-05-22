export enum Role {
  "user",
  "admin",
  "mrt_admin",
}
export interface User {
  id: number;
  account: string;
  password: string;
  nickname: string;
  role: Role;
  picture: null;
}
export interface LoginInfo {
  id: number;
  account: string;
  password: string;
  nickname: string;
  role: Role;
  picture: null;
  created_at: string;
  updated_at: string;
}
