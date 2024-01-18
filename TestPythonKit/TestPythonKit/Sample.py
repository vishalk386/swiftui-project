
# This is a comment. It is used to display useful
# information to people who read our code
 
def print_message(prefix, first_name):
    print(prefix + " " + first_name)
 
# Get user input
first_name = input("Enter a name: ")
 
# Check if the first_name variable is equal to 'Q'
# If so we will skip the next intended lines and go to
# line 21
while first_name != "Q":
 
    # Display the joined message to our user
    print_message("Hello", first_name)
    print_message("Goodbye", first_name)
    # Get the next name to print message for or check 'quit condition'
    first_name = input("Enter another name or 'Q' to quit: ").title()
 
print("Quitting greeter")
