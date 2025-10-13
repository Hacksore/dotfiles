interface User {
  id: number;
  name: string;
}

function getUser(): User {
  return {
    id: 1,
    name: "John"
  };
}

// Intentional type error for testing diagnostics
function badFunction(): string {
  return 123; // Error: number not assignable to string
}

export { getUser, badFunction };
