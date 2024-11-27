def validate_move(move):
    """
    Validates a chess move in standard algebraic notation.
    e.g., 'e2e4' (Pawn moves from e2 to e4).
    """
    if len(move) != 4:
        return False
    
    # Ensure the format matches [a-h][1-8][a-h][1-8]
    if (move[0] in 'abcdefgh' and move[2] in 'abcdefgh' and
        move[1] in '12345678' and move[3] in '12345678'):
        return True
    
    return False

def interpret_move(move):
    """
    Interprets a validated move and returns a detailed description.
    """
    start_pos = move[:2]
    end_pos = move[2:]
    return f"Move from {start_pos.upper()} to {end_pos.upper()}"
