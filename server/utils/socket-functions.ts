export const deleteClient = (id: string, clients: any) => {
  for (var key in clients) {
    if (clients[key].id == id) {
      delete clients[key];
    }
  }
};
