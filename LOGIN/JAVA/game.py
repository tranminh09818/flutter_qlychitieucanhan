import pygame



# Khởi tạo Pygame
pygame.init()



# Thiết lập màn hình


screen = pygame.display.set_mode((800, 600))


pygame.display.set_caption("Game Đối Kháng Đánh Quái Vật")


class Player:


    def __init__(self):


        self.image = pygame.image.load("player.png")  # Tải ảnh nhân vật


        self.rect = self.image.get_rect()  # Lấy kích thước và vị trí của ảnh


        self.rect.center = (400, 300)  # Vị trí ban đầu của nhân vật


        self.speed = 5  # Tốc độ di chuyển của nhân vật


        self.health = 100  # Máu của nhân vật



    def draw(self, screen):


        screen.blit(self.image, self.rect)  # Vẽ nhân vật lên màn hình



    def update(self, keys):


        if keys[pygame.K_LEFT]:


            self.rect.left -= self.speed


        if keys[pygame.K_RIGHT]:


            self.rect.right += self.speed


        if keys[pygame.K_UP]:


            self.rect.top -= self.speed


        if keys[pygame.K_DOWN]:


            self.rect.bottom += self.speed



        # Giữ nhân vật trong màn hình


        self.rect.left = max(0, self.rect.left)


        self.rect.right = min(800, self.rect.right)


        self.rect.top = max(0, self.rect.top)


        self.rect.bottom = min(600, self.rect.bottom)


class Monster:


    def __init__(self, type, x, y):


        self.type = type  # Loại quái vật


        self.image = pygame.image.load(f"monster_{type}.png")  # Tải ảnh quái vật


        self.rect = self.image.get_rect()


        self.rect.center = (x, y)


        self.speed = 3  # Tốc độ di chuyển của quái vật


        self.health = 100  # Máu của quái vật



    def draw(self, screen):


        screen.blit(self.image, self.rect)



    def update(self):


        if self.type == 1:  # Quái vật di chuyển sang trái


            self.rect.left -= self.speed


        elif self.type == 2:  # Quái vật di chuyển sang phải


            self.rect.right += self.speed


        else:  # Quái vật di chuyển ngẫu nhiên


            if random.random() < 0.5:


                self.rect.left -= self.speed


            else:


                self.rect.right += self.speed



        # Giữ quái vật trong màn hình


        self.rect.left = max(0, self.rect.left)


        self.rect.right = min(800, self.rect.right)


class Item:


    def __init__(self, type, x, y):


        self.type = type  # Loại vật phẩm


        self.image = pygame.image.load(f"item_{type}.png")  # Tải ảnh vật phẩm


        self.rect = self.image.get_rect()


        self.rect.center = (x, y)



    def draw(self, screen):


        screen.blit(self.image, self.rect)


running = True


while running:


    # Kiểm tra sự kiện


    for event in pygame.event.get():


        if event.type == pygame.QUIT:


            running = False



    # Di chuyển nhân vật


    keys = pygame.key.get_pressed()
    def jls_extract_def(player):
        return player


    jls_extract_var = jls_extract_def(player)

    jls_extract_var.update(keys)



    # Cập nhật quái vật


for monster in monsters:


    monster.update()



    # Kiểm tra va chạm giữa nhân vật và quái vật


    if player.rect.colliderect(monster.rect):


        player.health -= 10  # Giảm máu nhân vật


        if player.health <= 0:


            running = False  # Game over



        # Xử lý va chạm theo loại quái vật


        if monster.type == 1:


            # Quái vật 1 tấn công nhân vật
            pass


        elif monster.type == 2:


            # Quái vật 2 làm chậm nhân vật


            player.speed /= 2  # Giảm tốc độ di chuyển của nhân vật


            # Sau 5 giây, tốc độ trở lại bình thường


            pygame.time.set_timer(pygame.USEREVENT + 1, 5000)


        else:


            # Quái vật 3 đẩy lùi nhân vật


            player.rect.centerx -= 50  # Đẩy nhân vật về phía sau


            player.rect.left = max(0, player.rect.left)



# Thu thập vật phẩm


for item in items:


    if player.rect.colliderect(item.rect):


        if item.type == 1:


            player.health += 20  # Tăng máu


        elif item.type == 2:


            player.speed *= 1.5  # Tăng tốc độ di chuyển


        elif item.type == 3:


            # Tăng sức mạnh (chưa có code)
            pass


        items.remove(item)  # Xóa vật phẩm sau khi thu thập



# Vẽ màn hình


screen.fill((0, 0, 0))


player.draw(screen)


for monster in monsters:


    monster.draw(screen)


for item in items:


    item.draw(screen)



# Cập nhật bảng xếp hạng


if player.health > 0:


    high_score = max(high_score, player.health)


    font = pygame.font.Font(None, 36)


    text = font.render(f"Điểm cao nhất: {high_score}", True, (255, 255, 255))


    text_rect = text.get_rect(topleft=(10, 10))


    screen.blit(text, text_rect)



# Cập nhật màn hình
pygame.display.flip()



# Xử lý sự kiện timer


if event.type == pygame.USEREVENT + 1:


    player.speed *= 2  # Khôi phục tốc độ di chuyển của nhân vật


