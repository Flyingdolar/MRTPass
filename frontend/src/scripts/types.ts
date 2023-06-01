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
  picture: File;
}
export interface LoginInfo {
  id: number;
  account: string;
  password: string;
  nickname: string;
  role: Role;
  picture: File;
  created_at: string;
  updated_at: string;
}
export interface Post {
  id: number;
  topic: string;
  context: string;
  member_id: number;
  created_at: string;
  updated_at: string;
}
