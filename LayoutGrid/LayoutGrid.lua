local AddonName, Addon = ...

function Addon:ApplyActionBarsCenteredGrid(self, layoutChildren, stride, padding)
    if #layoutChildren == 0 then return end

    stride = math.min(stride, #layoutChildren)

    local firstChild = layoutChildren[1]
    local width = firstChild:GetWidth()
    local height = firstChild:GetHeight()

    if width == 0 or height == 0 then
        width, height = 36, 36
    end

    local spacing = padding
    local addButtonsToRight = self.addButtonsToRight
    local addButtonsToTop = self.addButtonsToTop

    local anchorPoint
    if addButtonsToTop then
        anchorPoint = addButtonsToRight and "BOTTOMLEFT" or "BOTTOMRIGHT"
    else
        anchorPoint = addButtonsToRight and "TOPLEFT" or "TOPRIGHT"
    end

    if self.isHorizontal then
        local itemStep = width + spacing
        local rowStep = height + spacing
        local fullRowWidth = (stride * width) + ((stride - 1) * spacing)
        local numRows = math.ceil(#layoutChildren / stride)

        for rowIndex = 0, numRows - 1 do
            local rowStart = rowIndex * stride + 1
            local rowEnd = math.min(rowStart + stride - 1, #layoutChildren)
            local itemCount = rowEnd - rowStart + 1

            local actualRowWidth = (itemCount * width) + ((itemCount - 1) * spacing)
            local xOffsetForRow = (fullRowWidth - actualRowWidth) / 2
            
            local yOffset = rowIndex * rowStep

            for i = rowStart, rowEnd do
                local child = layoutChildren[i]
                local itemIndex = i - rowStart
                local xOffset = xOffsetForRow + itemIndex * itemStep

                local finalX = addButtonsToRight and xOffset or -xOffset
                
                local finalY
                if addButtonsToTop then
                    finalY = yOffset
                else
                    finalY = -yOffset
                end
                child:ClearAllPoints()
                child:SetPoint(anchorPoint, self, anchorPoint, finalX, finalY)
            end
        end

        local totalWidth = (stride * width) + ((stride - 1) * spacing)
        local totalHeight = (numRows * height) + ((numRows - 1) * spacing)
        self:SetSize(totalWidth, totalHeight)
        
    else
        local itemStep = height + spacing
        local colStep = width + spacing
        local maxRows = stride
        local numCols = math.ceil(#layoutChildren / maxRows)
        local fullColHeight = (maxRows * height) + ((maxRows - 1) * spacing)

        for colIndex = 0, numCols - 1 do
            local colStart = colIndex * maxRows + 1
            local colEnd = math.min(colStart + maxRows - 1, #layoutChildren)
            local itemCount = colEnd - colStart + 1

            local actualColHeight = (itemCount * height) + ((itemCount - 1) * spacing)
            local yOffsetForCol = (fullColHeight - actualColHeight) / 2
            local xOffset = colIndex * colStep

            for i = colStart, colEnd do
                local child = layoutChildren[i]
                local itemIndex = i - colStart
                local yOffset = yOffsetForCol + itemIndex * itemStep

                local finalX = addButtonsToRight and xOffset or -xOffset
                local finalY = addButtonsToTop and yOffset or -yOffset

                child:ClearAllPoints()
                child:SetPoint(anchorPoint, self, anchorPoint, finalX, finalY)
            end
        end

        local totalWidth = (numCols * width) + ((numCols - 1) * spacing)
        local totalHeight = (maxRows * height) + ((maxRows - 1) * spacing)
        self:SetSize(totalWidth, totalHeight)
    end
end

function Addon:ApplyStandardGridLayout(self, layoutChildren, stride, padding)
    if #layoutChildren == 0 then return end

    local layoutFramesGoingUp = self.__layoutFramesGoingUp or self.layoutFramesGoingUp

    local xMultiplier = self.layoutFramesGoingRight and 1 or -1
    local yMultiplier = layoutFramesGoingUp and 1 or -1

    local layout
    if self.isHorizontal then
        layout = GridLayoutUtil.CreateStandardGridLayout(stride, padding, padding, xMultiplier, yMultiplier)
    else
        layout = GridLayoutUtil.CreateVerticalGridLayout(stride, padding, padding, xMultiplier, yMultiplier)
    end

    local anchorPoint
    if layoutFramesGoingUp then
        anchorPoint = self.layoutFramesGoingRight and "BOTTOMLEFT" or "BOTTOMRIGHT"
    else
        anchorPoint = self.layoutFramesGoingRight and "TOPLEFT" or "TOPRIGHT"
    end
    GridLayoutUtil.ApplyGridLayout(layoutChildren, AnchorUtil.CreateAnchor(anchorPoint, self, anchorPoint), layout) 
end

function Addon:ApplyCenteredGridLayout(self, layoutChildren, stride, padding)
    if #layoutChildren == 0 then return end

    stride = math.min(stride, #layoutChildren)

    local firstChild = layoutChildren[1]
    local width = firstChild:GetWidth()
    local height = firstChild:GetHeight()

    if width == 0 or height == 0 then
        width, height = 36, 36
    end

    local spacing = padding
    local layoutFramesGoingRight = self.layoutFramesGoingRight ~= false
    local layoutFramesGoingUp =  (self.__layoutFramesGoingUp or self.layoutFramesGoingUp) == true

    local anchorPoint
    if layoutFramesGoingUp then
        anchorPoint = layoutFramesGoingRight and "BOTTOMLEFT" or "BOTTOMRIGHT"
    else
        anchorPoint = layoutFramesGoingRight and "TOPLEFT" or "TOPRIGHT"
    end

    if self.isHorizontal then
        local itemStep = width + spacing
        local rowStep = height + spacing
        local xMultiplier = layoutFramesGoingRight and 1 or -1
        local yMultiplier = layoutFramesGoingUp and 1 or -1

        local fullRowWidth = (stride * width) + ((stride - 1) * spacing)
        local numRows = math.ceil(#layoutChildren / stride)

        for rowIndex = 0, numRows - 1 do
            local rowStart = rowIndex * stride + 1
            local rowEnd = math.min(rowStart + stride - 1, #layoutChildren)
            local itemCount = rowEnd - rowStart + 1

            local actualRowWidth = (itemCount * width) + ((itemCount - 1) * spacing)
            local xOffsetForRow = (fullRowWidth - actualRowWidth) / 2
            local yOffset = rowIndex * rowStep

            for i = rowStart, rowEnd do
                local child = layoutChildren[i]
                local itemIndex = i - rowStart
                local xOffset = xOffsetForRow + itemIndex * itemStep

                child:SetPoint(anchorPoint, self, anchorPoint, xOffset * xMultiplier, yOffset * yMultiplier)
            end
        end
    else
        local itemStep = height + spacing
        local colStep = width + spacing
        local xMultiplier = layoutFramesGoingRight and 1 or -1
        local yMultiplier = layoutFramesGoingUp and 1 or -1

        local maxRows = stride
        local numCols = math.ceil(#layoutChildren / maxRows)
        local fullColHeight = (maxRows * height) + ((maxRows - 1) * spacing)

        for colIndex = 0, numCols - 1 do
            local colStart = colIndex * maxRows + 1
            local colEnd = math.min(colStart + maxRows - 1, #layoutChildren)
            local itemCount = colEnd - colStart + 1

            local actualColHeight = (itemCount * height) + ((itemCount - 1) * spacing)
            local yOffsetForCol = (fullColHeight - actualColHeight) / 2
            local xOffset = colIndex * colStep

            for i = colStart, colEnd do
                local child = layoutChildren[i]
                local itemIndex = i - colStart
                local yOffset = yOffsetForCol + itemIndex * itemStep

                child:SetPoint(anchorPoint, self, anchorPoint, xOffset * xMultiplier, yOffset * yMultiplier)
            end
        end
    end
end