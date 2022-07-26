const rl = @import("raylib");
const print = @import("std").debug.print;
var player = rl.Rectangle{
    .x = 400,
    .y = 760,
    .width = 70,
    .height = 15,
};
var ball = rl.Rectangle {
    .x = 400,
    .y = 400,
    .width = 10,
    .height = 10,
};
const block = struct { 
    rec: rl.Rectangle,
    state: bool,
};
var spdX:f32 = -10;
var spdY:f32 = 5;

fn pysics(blockers: *[5][10]block ) void {
    
    
    ball.x += spdX;
    ball.y += spdY;
    if(ball.x + ball.width >= 800 or ball.x <= 0) {
        spdX = -spdX;
    }
    if(ball.y + ball.height >= 800 or ball.y <= 0) {
        spdY = -spdY;
    }
    if( ball.x + ball.width >= player.x and
        ball.x <= player.x + player.width and
        ball.y + ball.height >= player.y and
        ball.y < player.y + player.height){
            spdY = -spdY;
        }
    for (blockers.*) |blocksY,indexY| {
            for(blocksY) |blocksX,indexX| {
                if(blocksX.state == true){
                    if( ball.x + ball.width >= blocksX.rec.x   and
                        ball.x <= blocksX.rec.x + blocksX.rec.width and
                        ball.y + ball.height >= blocksX.rec.y  and
                        ball.y < blocksX.rec.y + blocksX.rec.height){
                            spdY = -spdY;
                            blockers[indexY][indexX].state = false;
                }
            }
        }
    } 
}

pub fn main() anyerror!void { 
    
    var blockers: [5][10]block = undefined;
    var vertical:usize = 0;
    var horizontal:usize = 0;
    var hpos :f32 = 10;
    var ypos :f32 = 20;
    while(vertical < 5){
        
        while(horizontal < 10){
            blockers[vertical][horizontal].rec = rl.Rectangle{
                .x = hpos,
                .y = ypos,
                .width = 73,
                .height = 20,
            };
            blockers[vertical][horizontal].state = true;
            
            hpos += 5 + 73;
            horizontal += 1;
        }
        vertical += 1;
        horizontal = 0;   
        hpos = 10;
        ypos += 20 + 5;        
    }
    
    rl.InitWindow(800,800,"Breakzig"); 
    rl.SetTargetFPS(60);
    while(!rl.WindowShouldClose()) {

        if(rl.IsKeyDown(rl.KeyboardKey.KEY_A)) {
            if(player.x - 10 >= 0){
                player.x -= 10;
            }
        }
        if(rl.IsKeyDown(rl.KeyboardKey.KEY_D)) {
            if(player.x + player.width + 10 <= 800){
                player.x += 10;
            }
        }
        pysics(&blockers);
        rl.BeginDrawing();
        rl.ClearBackground(rl.ORANGE);
        for (blockers) |blocksY| {
            for(blocksY) |blocksX| {
                if(blocksX.state == true){
                    rl.DrawRectangleRec(blocksX.rec,rl.WHITE);
                }
            }
        }
        rl.DrawRectangleRec(ball,rl.WHITE);
        rl.DrawRectangleRec(player, rl.WHITE);
    
        rl.EndDrawing();
    }
    rl.CloseWindow();
}