export enum Role {
  "user",
  "mrt_admin",
  "admin",
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
export interface Station {
  created_at: string;
  exit_Num: number;
  id: number;
  name: string;
  updated_at: string;
  x_Pos: number;
  y_Pos: number;
}
export interface Line {
  colorcode: string;
  created_at: string;
  id: number;
  linecolor: string;
  name: string;
  updated_at: string;
}
