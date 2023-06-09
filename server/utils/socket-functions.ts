export const deleteClient = (id: string, clients: any) => {
  for (var key in clients) {
    if (clients[key].id == id) {
      delete clients[key];
    }
  }
};

export const deleteInterest = (id: string, interest: any) => {
  for (var key in interest) {
    if (interest[key].id == id) {
      delete interest[key];
    }
  }
};
