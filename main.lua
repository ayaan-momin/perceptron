local function activate(x)
    return x > 0 and 1 or 0
end

local function createPerceptron(inputSize)
    local weights = {}
    for i = 1, inputSize do
        weights[i] = math.random() * 2 - 1  
    end
    local bias = math.random() * 2 - 1

    return {
        weights = weights,
        bias = bias,
        
    
        predict = function(self, inputs)
            local sum = self.bias
            for i = 1, #inputs do
                sum = sum + inputs[i] * self.weights[i]
            end
            return activate(sum)
        end,
        
        
        train = function(self, inputs, target, learningRate)
            local prediction = self:predict(inputs)
            local error = target - prediction
            
    
            for i = 1, #inputs do
                self.weights[i] = self.weights[i] + learningRate * error * inputs[i]
            end
            self.bias = self.bias + learningRate * error
        end
    }
end

local data = {
    {{0, 0}, 0},
    {{0, 1}, 1},
    {{1, 0}, 1},
    {{1, 1}, 0}
}

local p = createPerceptron(2)
local epochs = 1000
local learningRate = 0.1

for epoch = 1, epochs do
    for _, sample in ipairs(data) do
        local inputs, target = sample[1], sample[2]
        p:train(inputs, target, learningRate)
    end
end


for _, sample in ipairs(data) do
    local inputs, target = sample[1], sample[2]
    local prediction = p:predict(inputs)
    print(string.format("Inputs: %d, %d | Target: %d | Prediction: %d", 
                        inputs[1], inputs[2], target, prediction))
end

print("\n----------------xor-----------------")
print("Enter two numbers (0 or 1) separated by a space, or 'q' to quit.")

while true do
    io.write("Enter your input: ")
    local input = io.read()
    
    if input == "q" then
        print("Exiting...")
        break
    end
    
    local x1, x2 = input:match("(%d)%s(%d)")
    
    if x1 and x2 then
        x1 = tonumber(x1)
        x2 = tonumber(x2)
        
        if (x1 == 0 or x1 == 1) and (x2 == 0 or x2 == 1) then
            local prediction = p:predict({x1, x2})
            print(string.format("Inputs: %d, %d | Prediction: %d", x1, x2, prediction))
        else
            print("Please enter only 0 or 1 for each input.")
        end
    else
        print("Invalid input. Please enter two digits separated by a space.")
    end
end