package protocol

import (
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"math/bits"
)

const MaxFrame = 1024 * 1024

var LittleEndian = binary.LittleEndian
var BigEndian = binary.BigEndian
var ErrFrame = errors.New("invalid protocol frame")
var keys = []string{"00Na~1fd", "00xxgg!@", "<>>>SDSD", "012123AS", "<>>>sd!s", "dasdasds", "00xxLL:>", "<>>>$#@@", "01CscaSD", "<>>>*s^6", "kldk0MJI"}

type Message struct {
	ID      uint32 `json:"id"`
	Payload []byte `json:"payload"`
}

func ReadUint16(buffer []byte, offset int) uint16 { return LittleEndian.Uint16(buffer[offset:]) }
func ReadUint32(buffer []byte, offset int) uint32 { return LittleEndian.Uint32(buffer[offset:]) }
func ReadUint64(buffer []byte, offset int) uint64 { return LittleEndian.Uint64(buffer[offset:]) }
func WriteUint16(buffer []byte, offset int, value uint16) {
	LittleEndian.PutUint16(buffer[offset:], value)
}
func WriteUint32(buffer []byte, offset int, value uint32) {
	LittleEndian.PutUint32(buffer[offset:], value)
}
func WriteUint64(buffer []byte, offset int, value uint64) {
	LittleEndian.PutUint64(buffer[offset:], value)
}
func Uint32Bytes(value uint32) []byte {
	buffer := make([]byte, 4)
	WriteUint32(buffer, 0, value)
	return buffer
}
func Uint64Bytes(value uint64) []byte {
	buffer := make([]byte, 8)
	WriteUint64(buffer, 0, value)
	return buffer
}
func Block(data []byte, keyIndex int, decode bool) ([]byte, error) {
	if keyIndex < 0 || keyIndex >= len(keys) || len(data)%8 != 0 {
		return nil, ErrFrame
	}
	encoded := make([]byte, len(data))
	blockKey := LittleEndian.Uint64([]byte(keys[keyIndex]))
	for offset := 0; offset < len(data); offset += 8 {
		blockValue := ReadUint64(data, offset)
		if decode {
			blockValue = bits.RotateLeft64(blockValue^blockKey, -3)
		} else {
			blockValue = bits.RotateLeft64(blockValue, 3) ^ blockKey
		}
		WriteUint64(encoded, offset, blockValue)
	}
	return encoded, nil
}
func Encode(message Message) ([]byte, error) {
	paddedLength := (len(message.Payload) + 7) &^ 7
	if paddedLength+24 > MaxFrame {
		return nil, ErrFrame
	}
	inner := make([]byte, paddedLength+16)
	WriteUint32(inner, 0, message.ID)
	WriteUint32(inner, 6, uint32(len(message.Payload)))
	paddedPayload := make([]byte, paddedLength)
	copy(paddedPayload, message.Payload)
	encodedPayload, _ := Block(paddedPayload, 0, false)
	copy(inner[10:], encodedPayload)
	inner, _ = Block(inner, 0, false)
	frame := make([]byte, len(inner)+8)
	WriteUint16(frame, 0, 0xaaee)
	WriteUint16(frame, 2, uint16((len(inner)^0xbbcc)&0x88aa))
	WriteUint32(frame, 4, uint32(len(inner)))
	copy(frame[8:], inner)
	return frame, nil
}

type Decoder struct{ Buffer []byte }

func (decoder *Decoder) Feed(data []byte) ([]Message, error) {
	if len(decoder.Buffer)+len(data) > MaxFrame+65536 {
		return nil, ErrFrame
	}
	decoder.Buffer = append(decoder.Buffer, data...)
	var result []Message
	for len(decoder.Buffer) >= 8 {
		buffer := decoder.Buffer
		innerLength := int(ReadUint32(buffer, 4))
		if ReadUint16(buffer, 0) != 0xaaee || innerLength < 16 || innerLength%8 != 0 || innerLength+8 > MaxFrame || ReadUint16(buffer, 2) != uint16((innerLength^0xbbcc)&0x88aa) {
			return nil, ErrFrame
		}
		if len(buffer) < innerLength+8 {
			break
		}
		inner, _ := Block(buffer[8:8+innerLength], 0, true)
		length := int(ReadUint32(inner, 6))
		aligned := (length + 7) &^ 7
		if aligned+16 != innerLength {
			return nil, ErrFrame
		}
		payload, err := Block(inner[10:10+aligned], int(ReadUint16(inner, 4)), true)
		if err != nil {
			return nil, err
		}
		message := Message{ReadUint32(inner, 0), payload[:length]}
		if message.ID == 0 && length != 0 {
			return nil, ErrFrame
		}
		result = append(result, message)
		decoder.Buffer = decoder.Buffer[innerLength+8:]
	}
	return result, nil
}
func LoginEncode(message Message) []byte {
	frame := make([]byte, len(message.Payload)+10)
	WriteUint16(frame, 0, 0xaaee)
	WriteUint16(frame, 2, uint16((len(message.Payload)+2)^0xffdd)&0x88aa)
	WriteUint16(frame, 4, uint16(len(message.Payload)+2))
	WriteUint16(frame, 8, uint16(message.ID))
	copy(frame[10:], message.Payload)
	return frame
}
func ReadLogin(reader io.Reader) (byte, []byte, error) {
	header := make([]byte, 8)
	if _, err := io.ReadFull(reader, header); err != nil {
		return 0, nil, err
	}
	bodyLength := int(ReadUint16(header, 4))
	padding := int(header[7])
	if ReadUint16(header, 0) != 0xaaee || ReadUint16(header, 2) != uint16(bodyLength^0xffdd)&0x88aa || bodyLength < 2 || bodyLength+padding > 4096 || header[6] > 1 {
		return 0, nil, ErrFrame
	}
	body := make([]byte, bodyLength+padding)
	_, err := io.ReadFull(reader, body)
	return header[6], body[padding:], err
}
func LoginAck(account string, uid uint64) Message {
	payload := []byte{1}
	for _, text := range []string{account, fmt.Sprint(uid)} {
		lengthBytes := make([]byte, 2)
		BigEndian.PutUint16(lengthBytes, uint16(len(text)))
		payload = append(payload, lengthBytes...)
		payload = append(payload, []byte(text)...)
	}
	for index := 1; index <= 48; index++ {
		payload = append(payload, byte(index))
	}
	return Message{MsgSDKLoginResponse, payload}
}
func LoginDirectory(port uint16) Message {
	payload := make([]byte, 60)
	BigEndian.PutUint16(payload, 1)
	BigEndian.PutUint32(payload[2:], 1)
	copy(payload[6:], []byte{1, 0, 0, 127})
	BigEndian.PutUint16(payload[10:], port)
	payload[15] = 44
	WriteUint16(payload, 16, 100)
	WriteUint32(payload, 28, 1)
	WriteUint32(payload, 32, 999)
	copy(payload[40:], "Local Lobby")
	return Message{1012, payload}
}
func Catalog(port uint16) []Message {
	endpoint := make([]byte, 26)
	WriteUint32(endpoint, 0, 1)
	WriteUint16(endpoint, 4, port)
	copy(endpoint[6:], "127.0.0.1")
	lobby := make([]byte, 46)
	WriteUint32(lobby, 0, 1)
	copy(lobby[4:], "Local Lobby")
	WriteUint16(lobby, 25, 100)
	WriteUint32(lobby, 29, 1)
	WriteUint32(lobby, 42, 999)
	return []Message{{7080, endpoint}, {7070, lobby}}
}
func Bootstrap(inventory []byte, port uint16, gold, tickets uint32) []Message {
	settings := make([]byte, 44)
	WriteUint32(settings, 0, 10)
	WriteUint32(settings, 4, 5)
	WriteUint32(settings, 8, 255)
	WriteUint32(settings, 20, 1)
	core := make([]byte, 37)
	WriteUint32(core, 12, 1)
	WriteUint32(core, 16, gold)
	// A2B930 requires 57 bytes and copies them into the world directory.
	// RoleInfo initializes its history selection from the first DWORD; 1
	// represents a single local period, with no honour record configured yet.
	// This is directory initialization, not invented player statistics.
	honourDirectory := make([]byte, 57)
	WriteUint32(honourDirectory, 0, 1)
	messages := []Message{{1131, settings}, {1020, core}, {1230, Uint32Bytes(tickets)}, {1120, inventory}, {1035, honourDirectory}}
	return append(messages, Catalog(port)...)
}
func Lobby(port uint16) Message {
	payload := make([]byte, 52)
	WriteUint32(payload, 0, 1)
	copy(payload[4:24], "127.0.0.1")
	WriteUint16(payload, 24, port)
	WriteUint32(payload, 26, 1)
	return Message{MsgLobbyEntered, payload}
}
