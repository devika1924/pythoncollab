def greet(name):
    """Function to greet a user."""
    return f"Hello, {name}!"

def main():
    user_name = input("Enter your name: ")
    greeting = greet(user_name)
    print(greeting)

if __name__ == "__main__":
    main()