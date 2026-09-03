using Unity.Netcode;
using UnityEngine;
using UnityEngine.InputSystem;

namespace NGOgame.Networking
{
    /// <summary>소유자 클라이언트만 자기 캐릭터를 움직입니다.</summary>
    public class NetworkPlayerMover : NetworkBehaviour
    {
        [SerializeField] private float speed = 5f;

        private void Update()
        {
            // IsOwner 체크가 없으면 한 명의 입력이 모든 캐릭터를 움직입니다.
            if (!IsOwner) return;

            var keyboard = Keyboard.current;
            if (keyboard == null) return;

            var input = new Vector3(
                (keyboard.dKey.isPressed ? 1f : 0f) - (keyboard.aKey.isPressed ? 1f : 0f),
                (keyboard.wKey.isPressed ? 1f : 0f) - (keyboard.sKey.isPressed ? 1f : 0f),
                0f);

            transform.position += input.normalized * (speed * Time.deltaTime);
        }
    }
}
