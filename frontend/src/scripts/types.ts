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
export interface Lost {
  id?: number;
  item: string;
  photo?: any;
  time: string;
  location: string;
  lost_Attr: string;
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
export interface LineStation {
  linecolor: string;
  number: number;
  station: Station;
}
export interface AlotsLineStation {
  item: LineStation[];
}
export interface TimeTable {
  No: number;
  created_at: string;
  end: number;
  id: number;
  line: string;
  station_id: number;
  time: string;
  updated_at: string;
}
export interface AlotsTimeTable {
  line: string;
  timetable: TimeTable;
  to: string;
}
export interface Trans {
  Des: string;
  address: string;
  created_at: string;
  id: number;
  name: string;
  photo: File;
  type_: string;
  updated_at: string;
}
