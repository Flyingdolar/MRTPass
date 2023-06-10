import { createStore } from "vuex";
import type { LineStation, LoginInfo, User } from "./types";

export interface State {
  userinfo: LoginInfo | undefined;
  editinfo: User | undefined;
  currentlinestation: LineStation | undefined;
}

const store = createStore<State>({
  state: {
    userinfo: undefined,
    editinfo: undefined,
    currentlinestation: undefined,
  },
  getters: {
    userinfo: (state) => {
      return state.userinfo;
    },
    editinfo: (state) => {
      return state.editinfo;
    },
    currentline: (state) => {
      return state.currentlinestation;
    },
  },
  actions: {
    userinfo(ctx, userinfo) {
      ctx.commit("userinfo", userinfo);
    },
    editinfo(ctx, editinfo) {
      ctx.commit("editinfo", editinfo);
    },
    currentlinestation(ctx, currentlinestation) {
      ctx.commit("currentlinestation", currentlinestation);
    },
  },
  mutations: {
    async userinfo(state, userinfo) {
      state.userinfo = userinfo;
    },
    async editinfo(state, editinfo) {
      state.editinfo = editinfo;
    },
    async currentlinestation(state, currentlinestation) {
      state.currentlinestation = currentlinestation;
    },
  },
});

export default store;
