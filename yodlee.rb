###### Welcome to Blockspring!
###### To help you get started, below is a fully-commented sample function that prints out a simple welcome message.

# require the blockspring package.
require 'blockspring'

block = lambda do |request, response|

    # retrieve input parameters and assign to variables for convenience.
    first_name = request.params["first_name"]
    age = request.params["age"]

    # build our welcome message.
    welcome = "Hi! My name is #{first_name} and my age is #{age}"

    # add the message to the function's output.
    response.addOutput "intro", welcome

    # return the output.
	response.end
end

# pass your function into Blockspring.define. tells blockspring what function to run.
Blockspring.define(block)
